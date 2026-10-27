import Foundation

/// Turns a list of tasks and a time window into timed blocks. The AI only suggests; everything it says is checked
/// here, and anything that does not add up is thrown away in favour of an even split.
enum DayPlanner {
    struct Item { let id: UUID; let title: String }
    struct Block: Equatable { let id: UUID; let start: Date; let minutes: Int }

    static func prompt(_ items: [Item], start: Date, end: Date, cal: Calendar) -> String {
        func hm(_ d: Date) -> String { String(format: "%02d:%02d", cal.component(.hour, from: d), cal.component(.minute, from: d)) }
        let list = items.enumerated().map { "\($0.offset + 1). \($0.element.title)" }.joined(separator: "\n")
        return """
        Plan the rest of my day between \(hm(start)) and \(hm(end)).
        Tasks:
        \(list)

        Order them sensibly: important or demanding ones first, short ones to fill gaps. Estimate realistic minutes for each.
        Leave 5 minutes between tasks, no overlaps, and finish before \(hm(end)).
        Reply with exactly one line per task, nothing else, in this format:
        number | start time as HH:mm | minutes
        """
    }

    /// Returns nil unless every task is placed exactly once, inside the window, without overlap.
    static func parse(_ text: String, items: [Item], start: Date, end: Date, cal: Calendar) -> [Block]? {
        let re = try! NSRegularExpression(pattern: #"^\s*(\d+)\s*[|.:-]?\s*\|?\s*(\d{1,2}):(\d{2})\s*\|\s*(\d{1,3})"#)
        var blocks: [Block] = []
        var seen = Set<Int>()
        for line in text.split(whereSeparator: \.isNewline) {
            let s = String(line)
            guard let m = re.firstMatch(in: s, range: NSRange(s.startIndex..., in: s)) else { continue }
            func g(_ i: Int) -> Int { Int((s as NSString).substring(with: m.range(at: i))) ?? -1 }
            let n = g(1), h = g(2), mi = g(3), mins = g(4)
            guard (1...items.count).contains(n), seen.insert(n).inserted,
                  (0..<24).contains(h), (0..<60).contains(mi), (5...240).contains(mins),
                  let when = cal.date(bySettingHour: h, minute: mi, second: 0, of: start) else { return nil }
            blocks.append(Block(id: items[n - 1].id, start: when, minutes: mins))
        }
        guard blocks.count == items.count else { return nil }
        blocks.sort { $0.start < $1.start }
        for (i, b) in blocks.enumerated() {
            let finish = b.start.addingTimeInterval(Double(b.minutes) * 60)
            if b.start < start || finish > end { return nil }
            if i + 1 < blocks.count && finish > blocks[i + 1].start { return nil }
        }
        return blocks
    }

    /// Equal blocks in the given order, 5 minutes apart, 15 to 90 minutes long. Tasks that do not fit are left out.
    static func even(_ items: [Item], start: Date, end: Date) -> [Block] {
        guard !items.isEmpty else { return [] }
        let total = Int(end.timeIntervalSince(start) / 60)
        let per = min(90, max(15, (total - 5 * (items.count - 1)) / items.count / 5 * 5))
        var out: [Block] = []
        var t = start
        for item in items {
            let finish = t.addingTimeInterval(Double(per) * 60)
            guard finish <= end else { break }
            out.append(Block(id: item.id, start: t, minutes: per))
            t = finish.addingTimeInterval(5 * 60)
        }
        return out
    }
}
