#if os(visionOS)

import Foundation
import RealityKit

/// Utilities for configuring image‑based environment lighting in RealityKit.
///
/// Use this class to load an environment texture and apply image‑based lighting (IBL)
/// to entities in a visionOS scene.
@MainActor public class EnvironmentLighting {

    /// Applies an image‑based light environment to the specified entity.
    ///
    /// This method loads an environment texture and configures both an
    /// ``ImageBasedLightComponent`` and an ``ImageBasedLightReceiverComponent``
    /// so that the entity contributes to and receives lighting from the provided environment map.
    ///
    /// - Parameters:
    ///   - environmentName: The name of the environment texture resource.
    ///   - bundle: The bundle to load the texture from. Pass `nil` to use the main bundle.
    ///   - entity: The entity that will be assigned the image‑based lighting components.
    ///   - intensityExponent: A scalar that adjusts the brightness of the light
    ///     environment. Higher values produce a more intense lighting contribution.
    /// - Throws: An error if the texture resource cannot be loaded.
    public static func add(
        _ environmentName: String,
        in bundle: Bundle? = nil,
        to entity: Entity,
        intensityExponent: Float = 0.25
    ) async throws {

        // Load the light environment texture.
        let resource = try await EnvironmentResource(
            named: environmentName,
            in: bundle
        )

        // Create light component with texture and intensity exponent.
        let iblComponent = ImageBasedLightComponent(
            source: .single(resource),
            intensityExponent: intensityExponent
        )

        let receiverComponent = ImageBasedLightReceiverComponent(
            imageBasedLight: entity
        )

        entity.components.set(iblComponent)
        entity.components.set(receiverComponent)
    }
}

#endif
