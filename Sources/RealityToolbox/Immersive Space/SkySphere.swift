#if os(visionOS)

import Foundation
import RealityKit

/// Errors that can occur while working with a ``SkySphere``.
public enum SkySphereError: Swift.Error {
    /// The sky sphere entity is missing a ``ModelComponent`` and cannot be updated.
    case missingModelComponent
}

/// A large inverted sphere that renders a sky texture around the user.
///
/// Use this entity to display an environment texture in a RealityKit scene on visionOS.
@MainActor public final class SkySphere: Entity {

    /// The name of the currently applied sky texture resource.
    ///
    /// This value reflects the last texture that was used to create or update the sky sphere.
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

    /// Creates a sky sphere and adds it as a child of the given entity.
    ///
    /// This convenience method loads the specified texture, builds a ``SkySphere``,
    /// and inserts it into the scene hierarchy as a child of `entity`.
    ///
    /// - Parameters:
    ///   - textureName: The name of the texture resource to use for the sky.
    ///   - bundle: The bundle from which to load the texture resource. Pass `nil`
    ///     to use the main bundle.
    ///   - entity: The parent entity that will own the sky sphere as a child.
    /// - Throws: An error if the texture cannot be loaded or the material cannot be created.
    public static func add(
        _ textureName: String,
        in bundle: Bundle? = nil,
        to entity: Entity
    ) async throws {
        let skySphere = try await make(textureName, in: bundle)
        entity.addChild(skySphere)
    }

    // MARK: Make SkySphere Entity

    /// Creates a sky sphere entity configured with the specified texture.
    ///
    /// This method loads the texture resource, builds an inverted sphere mesh, and
    /// assigns an unlit material so the sky appears evenly lit from all directions.
    ///
    /// - Parameters:
    ///   - textureName: The name of the texture resource to use for the sky.
    ///   - bundle: The bundle from which to load the texture resource. Pass `nil`
    ///     to use the main bundle.
    /// - Returns: A fully configured ``SkySphere`` entity that you can add to a scene.
    /// - Throws: An error if the texture or material cannot be created.
    public static func make(
        _ textureName: String,
        in bundle: Bundle? = nil
    ) async throws -> SkySphere {
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

    /// Applies a new sky texture to the existing sky sphere.
    ///
    /// This method replaces the current material with one that uses the given texture
    /// and updates ``textureName`` to reflect the new resource.
    ///
    /// - Parameters:
    ///   - textureName: The name of the new texture resource to apply.
    ///   - bundle: The bundle from which to load the texture resource. Pass `nil`
    ///     to use the main bundle.
    /// - Throws: An error if the texture or material cannot be created, or if the
    ///   sky sphere is missing a required ``ModelComponent``.
    public func applyTexture(
        _ textureName: String,
        in bundle: Bundle? = nil
    ) async throws {
        guard var modelComponent = components[ModelComponent.self] else {
            throw SkySphereError.missingModelComponent
        }
        let material = try await SkySphere.makeMaterial(textureName, in: bundle)
        modelComponent.materials = [material]
        components.set(modelComponent)
        self.textureName = textureName
    }

    // MARK: Private Helpers

    private static func makeMaterial(
        _ textureName: String,
        in bundle: Bundle?
    ) async throws -> RealityKit.Material {
        let resource = try await TextureResource(named: textureName)
        var material = UnlitMaterial()
        let texture = MaterialParameters.Texture(resource)
        material.color = UnlitMaterial.BaseColor(texture: texture)
        return material
    }
}

#endif
