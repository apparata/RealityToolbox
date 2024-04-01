import Foundation
import RealityKit

extension Entity {

    // MARK: Update Comp. If Present

    /// Searches the entity's set of components for a component of the give type. Then,
    /// if the component is found, it is passed to the update closure for modification.
    /// - Parameter type: A component type to look for.
    /// - Parameter update: Closure that apply arbitrary modifications to the component.
    public func updateComponentIfPresent<T: Component>(_ type: T.Type, update: (inout T) -> Void) {
        #if os(visionOS)
        guard var component = components[type] else {
            return
        }
        update(&component)
        components[T.self] = component
        #else
        guard var component = components[type] as? T else {
            return
        }
        update(&component)
        components[T.self] = component
        #endif
    }

    // MARK: Update / Create Component

    /// Searches the entity's set of components for a component of the give type, or creates it. Then,
    /// the found or created component is passed to the update closure for modification.
    /// - Parameter type: A component type to look for.
    /// - Parameter update: Closure that apply arbitrary modifications to the component.
    /// - Parameter createIfNotPresent: Closure that creates a component if it does not already exist.
    public func updateComponent<T: Component>(_ type: T.Type, update: (inout T) -> Void, createFirstIfNotPresent: () -> T) {
        #if os(visionOS)
        var component = components[type] ?? createFirstIfNotPresent()
        update(&component)
        components[T.self] = component
        #else
        var component = components[type] as? T ?? createFirstIfNotPresent()
        update(&component)
        components[T.self] = component
        #endif
    }

    // MARK: Update Req. Component

    /// Searches the entity's set of components for a component of the give type. Then,
    /// the created component is passed to the update closure for modification.
    /// - Parameter type: A component type to look for.
    /// - Parameter update: Closure that apply arbitrary modifications to the component.
    public func updateRequiredComponent<T: Component>(_ type: T.Type, _ update: (inout T) -> Void) {
        var component = requiredComponent(type)
        update(&component)
        components[T.self] = component
    }
}
