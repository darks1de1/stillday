import Foundation

/// Guesses whether you are avoiding your next task, from what the app can honestly see: how often you open it
/// without doing anything, nudges you did not answer, a planned time that passed, a task moved forward again and
/// again, a long quiet stretch, a ladder you began and left. It cannot see the rest of your phone.
enum Stuck {
    struct Signals {
        var looks = 0              // times you opened the app since you last did anything
        var ignored = 0            // latest nudges in a row that got no answer
        var overdueMinutes = 0     // minutes past this task's planned start
        var carried = 0            // days this task has been moved forward
        var idleHours = 0.0        // hours since your last action, during the day
        var stalled = false        // you started its ladder and stopped
    }

    static let threshold = 3

    private static func points(_ s: Signals) -> [(Int, String)] {
        var p: [(Int, String)] = []
        if s.looks >= 4 { p.append((3, "You have opened Stillday \(s.looks) times without starting this.")) }
        else if s.looks >= 2 { p.append((2, "You have opened Stillday \(s.looks) times without starting this.")) }
        if s.ignored >= 3 { p.append((3, "Several nudges have gone unanswered.")) }
        else if s.ignored >= 2 { p.append((2, "A couple of nudges have gone unanswered.")) }
        if s.overdueMinutes >= 60 { p.append((3, "It is well past its planned time.")) }
        else if s.overdueMinutes >= 10 { p.append((2, "It is past its planned time.")) }
        if s.carried >= 2 { p.append((3, "It has been moved forward \(s.carried) times.")) }
        else if s.carried >= 1 { p.append((2, "It has been waiting since yesterday.")) }
        if s.idleHours >= 4 { p.append((2, "Nothing done for a few hours.")) }
        else if s.idleHours >= 2 { p.append((1, "Nothing done for a while.")) }
        if s.stalled { p.append((2, "You started this and stopped.")) }
        return p
    }

    static func score(_ s: Signals) -> Int { points(s).reduce(0) { $0 + $1.0 } }
    static func needsHelp(_ s: Signals) -> Bool { score(s) >= threshold }

    /// The strongest reason, in plain words.
    static func reason(_ s: Signals) -> String? { points(s).max { $0.0 < $1.0 }?.1 }
}
