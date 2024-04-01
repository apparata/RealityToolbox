import Foundation
import RealityKit
import simd

extension Entity {

    /// Returns the position of the entity specified in the app's coordinate system.
    public var scenePosition: SIMD3<Float> {
        get { position(relativeTo: nil) }
        set { setPosition(newValue, relativeTo: nil) }
    }

    /// Returns the orientation of the entity specified in the app's coordinate system.
    public var sceneOrientation: simd_quatf {
        get { orientation(relativeTo: nil) }
        set { setOrientation(newValue, relativeTo: nil) }
    }
}
