import Foundation
import RealityKit

extension Entity {

    // MARK: Component of Type

    /// Searches the entity's set of components for a component of the given type and returns it, if found.
    /// - Parameter type: A component type to look for.
    /// - Returns: A component of the given type, if the entity has one. Otherwise, `nil`
    public func componentOfType<T: Component>(_ type: T.Type) -> T? {
        components[type]
    }

    // MARK: Required Component

    /// Searches the entity's set of components for a component of the given type, that is
    /// **required** to be there, and returns it. If there is none, it crashes with a `fatalError`.
    /// - Parameter type: A component type to look for.
    /// - Returns: A component of the given type, if the entity has one. Otherwise,  it crashes.
    public func requiredComponent<T: Component>(_ type: T.Type) -> T {
        guard let component = components[type] else {
            fatalError("The entity \(name) doesn't have a required component of type \(Swift.type(of: T.self))")
        }
        return component
    }

    // MARK: Find Ancestor w/ Component

    /// Recursively traverses up the node tree to find an ancestor node that has a component of the given type.
    /// - Parameter type: A component type to look for.
    public func findAncestorWithComponentOfType<T: Component>(_ type: T.Type) -> Entity? {
        if let parent {
            if parent.components[type] != nil {
                return parent
            } else {
                return parent.findAncestorWithComponentOfType(type)
            }
        } else {
            return nil
        }
    }
}
