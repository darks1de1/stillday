import AudioToolbox

/// Apple's built-in system sounds. They follow the Ring/Silent switch and are not documented by Apple,
/// so an ID that does not exist on a given iOS version is simply silent.
enum Sound {
    case complete, cleared, add, archive, trash, restore, micOn, micOff

    private var id: SystemSoundID {
        switch self {
        case .complete: 1057   // Tink
        case .cleared: 1111    // confirm chime
        case .add: 1104        // Tock
        case .archive: 1001    // Mail Sent whoosh
        case .trash: 1112      // soft cancel
        case .restore: 1103    // key click
        case .micOn: 1113      // begin recording
        case .micOff: 1114     // end recording
        }
    }

    static func play(_ s: Sound) { AudioServicesPlaySystemSound(s.id) }
}
