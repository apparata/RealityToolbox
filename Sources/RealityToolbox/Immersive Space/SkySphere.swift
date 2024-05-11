#if os(visionOS)

import Foundation
import RealityKit

// MARK: - SkySphereError

public enum SkySphereError: Swift.Error {
    case missingModelComponent
}

// MARK: - SkySphere

@MainActor public final class SkySphere: Entity {

    public private(set) var textureName: String

    private init(textureName: String) {
        self.textureName = textureName
        super.init()
    }

    @available(*, unavailable)
    internal required init() {
        fatalError()
    }

    // MARK: Make & Add SkySphere Entity

    public static func add(_ textureName: String, in bundle: Bundle? = nil, to entity: Entity) async throws {
        let skySphere = try await make(textureName, in: bundle)
        entity.addChild(skySphere)
    }

    // MARK: Make SkySphere Entity

    /// Initialize a SkySphere entity, after loading its texture.
    public static func make(_ textureName: String, in bundle: Bundle? = nil) async throws -> SkySphere {
        let material = try await makeMaterial(textureName, in: bundle)
        let entity = SkySphere(textureName: textureName)
        entity.components.set(ModelComponent(
            mesh: .generateSphere(radius: 1000),
            materials: [material]
        ))

        // Flip the winding order of the triangles to invert backface culling,
        // essentially turning the sphere inside-out.
        entity.scale *= .init(x: -1, y: 1, z: 1)

        return entity
    }

    // MARK: Apply Texture

    public func applyTexture(_ textureName: String, in bundle: Bundle? = nil) async throws {
        guard var modelComponent = components[ModelComponent.self] else {
            throw SkySphereError.missingModelComponent
        }
        let material = try await SkySphere.makeMaterial(textureName, in: bundle)
        modelComponent.materials = [material]
        components.set(modelComponent)
        self.textureName = textureName
    }

    // MARK: Private Helpers

    private static func makeMaterial(_ textureName: String, in bundle: Bundle?) async throws -> RealityKit.Material {
        let resource = try await TextureResource(named: textureName)
        var material = UnlitMaterial()
        let texture = MaterialParameters.Texture(resource)
        material.color = UnlitMaterial.BaseColor(texture: texture)
        return material
    }
}

#endif
