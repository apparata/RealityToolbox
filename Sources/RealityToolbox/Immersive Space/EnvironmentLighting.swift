import Foundation
import RealityKit

@MainActor public class EnvironmentLighting {

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
