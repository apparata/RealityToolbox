import Foundation
import RealityKit

extension Entity {

    /// Returns the named entity if it's in the tree, or crashes with a fatal error otherwise.
    public func findRequiredEntity(named name: String) -> Entity {
        guard let entity = findEntity(named: name) else {
            fatalError("The required entity \(name) cannot be found")
        }
        return entity
    }
}

extension Sequence where Element: Entity {

    /// Returns the named entity if it's in the tree, or crashes with a fatal error otherwise.
    public func findRequiredEntity(named name: String) -> Entity {
        for entity in self {
            if let requiredEntity = entity.findEntity(named: name) {
                return requiredEntity
            }
        }
        fatalError("The required entity \(name) cannot be found")
    }
}

extension Optional<Entity> {

    /// Unwraps the entity on purpose or crashes. Meant for entities that must exist.
    public var required: Entity {
        guard let entity = self else {
            fatalError("The required entity is nil")
        }
        return entity
    }
}
