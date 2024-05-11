import Foundation
import RealityKit

extension AnimationPlaybackController {

    /// Listens for the `PlaybackCompleted` event and then returns.
    @MainActor public func completion() async {
        guard let entity else {
            return
        }
        guard let scene = entity.scene else {
            return
        }
        let publisher = scene.publisher(for: AnimationEvents.PlaybackCompleted.self, on: entity)
        _ = await publisher.values.first(where: { [weak self] event in
            event.playbackController == self
        })
    }
}
