//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

#if os(macOS) || os(iOS) || os(tvOS)

import Foundation
import RealityKit

/// A plane entity that renders a world-space grid using a custom RealityKit surface shader.
///
/// ``GridPlane`` uses a `CustomMaterial` backed by the `gridPlane` surface shader to draw
/// decimeter and meter grid lines on a large plane. Update the material’s custom parameters
/// each frame (or when the camera moves) to control line thickness and distance fading.
public class GridPlane: Entity {

    /// The custom unlit material used to render the grid.
    ///
    /// The material is backed by the `gridPlane` surface shader and is configured for
    /// transparent blending and double-sided rendering.
    public private(set) var material: CustomMaterial

    /// The underlying model entity that displays the plane mesh using ``material``.
    public private(set) var model: ModelEntity!

    /// Creates a grid plane entity configured with the `gridPlane` surface shader.
    ///
    /// The grid is rendered on a 50×50 plane mesh using an unlit `CustomMaterial`.
    /// The material is configured with transparent blending and no face culling so the
    /// grid is visible from both sides.
    public required init() {

        do {
            let shader = CustomMaterial.SurfaceShader(named: "gridPlane", in: Shaders.shared.library)
            material = try CustomMaterial(surfaceShader: shader, lightingModel: .unlit)
            material.opacityThreshold = 0.0
            material.blending = .transparent(opacity: 0.9999)
            material.faceCulling = .none
            material.custom.value = SIMD4<Float>(1.0, 0.0, 0.0, 0.0)
        } catch {
            fatalError(error.localizedDescription)
        }

        super.init()

        let mesh = MeshResource.generatePlane(width: 50, depth: 50)

        model = ModelEntity(mesh: mesh, materials: [material])
        addChild(model)
    }

    /// Updates the grid’s shader parameters.
    ///
    /// Call this method as the camera moves (for example, once per frame) to keep the
    /// grid’s distance-based fade and line scaling consistent.
    ///
    /// - Parameters:
    ///   - scale: A scale factor applied to line widths in the shader. Larger values
    ///     make grid lines appear thicker.
    ///   - cameraPosition: The camera’s world-space position, used by the shader to
    ///     fade grid lines with distance.
    public func update(scale: Float, cameraPosition: SIMD3<Float>) {
        material.custom.value = SIMD4<Float>(
            cameraPosition.x,
            cameraPosition.y,
            cameraPosition.z,
            scale
        )
        model.updateRequiredComponent(ModelComponent.self) { component in
            component.materials = [material]
        }
    }
}

#endif
