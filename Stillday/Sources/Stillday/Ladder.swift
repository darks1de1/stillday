import Foundation

/// A ladder is a task cut into steps so small that each one is easy to start. The first takes seconds, and every
/// step is a win on its own, so stopping early still counts.
enum Ladder {
    static func prompt(_ title: String) -> String {
        """
        I keep putting off this task: "\(title)".
        Break it into 4 to 6 steps so small that each is hard to refuse. The first step must take under 30 seconds and need no willpower.
        Make the last step the real task. Each step is one short line starting with a verb.
        Reply with exactly one step per line, nothing else.
        """
    }

    static func smallerPrompt(_ step: String) -> String {
        "Rewrite this step so it is much smaller, something that takes under 30 seconds. One short line, nothing else: \(step)"
    }

    /// Reads numbered or bulleted lines. Returns nil unless there are 3 to 7 usable steps.
    static func parse(_ text: String) -> [String]? {
        let steps = text.split(whereSeparator: \.isNewline).map { clean(String($0)) }.filter { $0.count >= 3 && $0.count <= 90 }
        return (3...7).contains(steps.count) ? steps : nil
    }

    /// First usable line, for a single rewritten step.
    static func parseOne(_ text: String) -> String? {
        text.split(whereSeparator: \.isNewline).map { clean(String($0)) }.first { $0.count >= 3 && $0.count <= 90 }
    }

    /// Drops list numbering, bullets, quotes and markdown stars.
    private static func clean(_ line: String) -> String {
        var s = line
        let lead = try! NSRegularExpression(pattern: #"^\s*(?:\d+\s*[.):-]|[-•*])\s*"#)
        if let m = lead.firstMatch(in: s, range: NSRange(s.startIndex..., in: s)), let r = Range(m.range, in: s) { s.removeSubrange(r) }
        return s.trimmingCharacters(in: CharacterSet(charactersIn: " \t\"“”*"))
    }

    /// Used when Apple Intelligence is not available. The gym ladder is the one you already use on yourself.
    static func fallback(_ title: String) -> [String] {
        let t = title.lowercased()
        if ["gym", "workout", "work out", "exercise", "run", "lift", "yoga"].contains(where: t.contains) {
            return ["Put on your workout clothes", "Put on your shoes", "Step into the elevator or out the door",
                    "Walk in. You do not have to work out", "Do one exercise"]
        }
        return ["Put what you need for it where you can see it", "Open it or start it for one minute only",
                "Keep going for two more minutes", "Do the next piece", "Finish it"]
    }

    static func key(_ title: String) -> String { title.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) }
}
