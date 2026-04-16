import Foundation
import Combine

class SceneState: ObservableObject {
    @Published var ghostVisible: Bool = true
    @Published var playbackSpeed: Float = 1.0
}
