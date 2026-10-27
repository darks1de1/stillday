import SwiftUI
import Speech
import AVFoundation
import Observation

/// Turns spoken sentences into separate task titles. Deliberately simple; the review sheet lets you fix mistakes.
enum VoiceParser {
    static func tasks(from text: String) -> [String] {
        let splitter = #"(?i)[,.;!?]| and then | then | and also | also | after that | plus | and "#
        let lead = #"(?i)^((i )?(need|want|have|got|should|must|am going) to |i'm going to |i will |i'll |remind me to |let me |please |today i |today |to )+"#
        var seen = Set<String>()
        return text
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: splitter, with: "|", options: .regularExpression)
            .split(separator: "|")
            .map { $0.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: lead, with: "", options: .regularExpression) }
            .filter { $0.count > 2 && !["um", "uh", "uhm", "umm"].contains($0.lowercased()) }
            .map { $0.prefix(1).uppercased() + $0.dropFirst() }
            .filter { seen.insert($0.lowercased()).inserted }
    }
}

@MainActor @Observable
final class VoiceCapture {
    var transcript = ""
    var listening = false
    var error: String?

    @ObservationIgnored private let recognizer = SFSpeechRecognizer(locale: Locale.current)
    @ObservationIgnored private let engine = AVAudioEngine()
    @ObservationIgnored private var request: SFSpeechAudioBufferRecognitionRequest?
    @ObservationIgnored private var task: SFSpeechRecognitionTask?

    private static func authorize() async -> Bool {
        let speech = await withCheckedContinuation { c in
            SFSpeechRecognizer.requestAuthorization { c.resume(returning: $0 == .authorized) }
        }
        guard speech else { return false }
        return await AVAudioApplication.requestRecordPermission()
    }

    func start() async {
        guard !listening else { return }
        error = nil
        transcript = ""
        guard await Self.authorize() else {
            error = "Allow Microphone and Speech Recognition for Stillday in Settings."
            return
        }
        guard let recognizer, recognizer.isAvailable else {
            error = "Speech recognition isn't available right now."
            return
        }
        Sound.play(.micOn)   // before the session switches to record, which silences system sounds
        try? await Task.sleep(nanoseconds: 350_000_000)
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.record, mode: .measurement, options: .duckOthers)
            try session.setActive(true, options: .notifyOthersOnDeactivation)

            let req = SFSpeechAudioBufferRecognitionRequest()
            req.shouldReportPartialResults = true
            req.requiresOnDeviceRecognition = recognizer.supportsOnDeviceRecognition
            request = req

            let input = engine.inputNode
            input.removeTap(onBus: 0)
            input.installTap(onBus: 0, bufferSize: 1024, format: input.outputFormat(forBus: 0)) { buffer, _ in
                req.append(buffer)
            }
            engine.prepare()
            try engine.start()
            listening = true

            task = recognizer.recognitionTask(with: req) { [weak self] result, err in
                Task { @MainActor in
                    guard let self else { return }
                    if let r = result { self.transcript = r.bestTranscription.formattedString }
                    if err != nil || result?.isFinal == true { self.stop() }
                }
            }
        } catch {
            self.error = "Couldn't start the microphone."
            stop()
        }
    }

    func stop() {
        let wasListening = listening
        defer { if wasListening { Sound.play(.micOff) } }
        if engine.isRunning {
            engine.stop()
            engine.inputNode.removeTap(onBus: 0)
        }
        request?.endAudio()
        request = nil
        task = nil
        listening = false
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
}

private struct Draft: Identifiable {
    let id = UUID()
    var text: String
}

/// Say your tasks, check them, add them. Nothing is saved until you press Add.
struct VoiceSheet: View {
    let day: Date
    @Environment(Store.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var voice = VoiceCapture()
    @State private var drafts: [Draft] = []

    var body: some View {
        VStack(spacing: 16) {
            Label12(text: voice.listening ? "Listening" : drafts.isEmpty ? "Tap to speak" : "Check and add")
                .padding(.top, 26)

            Button {
                if voice.listening { voice.stop() } else { Task { await voice.start() } }
            } label: { Orb(listening: voice.listening) }
                .buttonStyle(PressStyle())
                .sensoryFeedback(.impact(weight: .medium), trigger: voice.listening)

            Group {
                if let e = voice.error {
                    Text(e).foregroundStyle(Theme.trash)
                } else if voice.transcript.isEmpty {
                    Text("Try: “Call the dentist, send the invoice and read for twenty minutes.”").foregroundStyle(Theme.mute)
                } else {
                    Text(voice.transcript).foregroundStyle(Theme.ink)
                }
            }
            .font(Theme.serif(20)).multilineTextAlignment(.center).padding(.horizontal, 28)

            ScrollView {
                VStack(spacing: 0) {
                    ForEach($drafts) { $d in
                        HStack(spacing: 12) {
                            Circle().stroke(Theme.ink, lineWidth: 1.5).frame(width: 18, height: 18)
                            TextField("Task", text: $d.text).font(Theme.sans(16, .medium))
                            Button {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) { drafts.removeAll { $0.id == d.id } }
                            } label: {
                                Image(systemName: "xmark").font(.system(size: 12, weight: .semibold)).foregroundStyle(Theme.mute)
                                    .frame(width: 32, height: 32)
                            }
                        }
                        .padding(.vertical, 10)
                        .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity), removal: .opacity))
                        Divider().overlay(Theme.line)
                    }
                }
                .padding(.horizontal, 24)
            }
            .scrollIndicators(.hidden)

            Button(action: add) {
                Text(drafts.isEmpty ? "Add" : "Add \(drafts.count) task\(drafts.count == 1 ? "" : "s")")
                    .font(Theme.sans(16, .semibold)).foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .background(Theme.next.opacity(drafts.isEmpty ? 0.35 : 1), in: Capsule())
            }
            .buttonStyle(PressStyle())
            .disabled(drafts.isEmpty)
            .padding(.horizontal, 24).padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.bg.ignoresSafeArea())
        .task { await voice.start() }
        .onDisappear { voice.stop() }
        .onChange(of: voice.transcript) { _, t in refresh(t) }
        .onChange(of: voice.listening) { _, on in if !on { refresh(voice.transcript) } }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }

    private func refresh(_ t: String) {
        let next = VoiceParser.tasks(from: t)
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) { drafts = next.map { Draft(text: $0) } }
    }

    private func add() {
        let titles = drafts.map(\.text).filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        guard !titles.isEmpty else { return }
        voice.stop()
        withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) { titles.forEach { store.add($0, on: day) } }
        store.showToast("Added \(titles.count) task\(titles.count == 1 ? "" : "s")")
        dismiss()
    }
}

struct Orb: View {
    let listening: Bool

    var body: some View {
        TimelineView(.animation(minimumInterval: nil, paused: !listening)) { ctx in
            let t = ctx.date.timeIntervalSinceReferenceDate
            ZStack {
                ForEach(0..<3, id: \.self) { i in
                    let p = (t / 2.4 + Double(i) / 3).truncatingRemainder(dividingBy: 1)
                    Circle().stroke(Theme.next, lineWidth: 1.5)
                        .frame(width: 84, height: 84)
                        .scaleEffect(1 + p * 0.9)
                        .opacity(listening ? (1 - p) * 0.55 : 0)
                }
                Circle()
                    .fill(LinearGradient(colors: [Theme.next.opacity(0.8), Theme.next], startPoint: .top, endPoint: .bottom))
                    .frame(width: 84, height: 84)
                    .shadow(color: Theme.next.opacity(listening ? 0.45 : 0.2), radius: listening ? 22 : 10)
                Image(systemName: listening ? "waveform" : "mic.fill")
                    .font(.system(size: 30, weight: .medium)).foregroundStyle(.white)
            }
        }
        .frame(width: 170, height: 170)
    }
}
