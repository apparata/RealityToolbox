import Foundation
import RealityKit

extension Entity {

    /// Return the first entity in the subtree, if any, for which the condition returns `true`.
    public func firstEntity(where condition: (Entity) -> Bool) -> Entity? {
        if condition(self) {
            return self
        } else {
            for child in children {
                if let entity = child.firstEntity(where: condition) {
                    return entity
                }
            }
            return nil
        }
    }

    /// Find and return the first entity of the specified type in the subtree, if any.
    public func firstEntity<T>( _ type: T.Type) -> T? {
        if let entity = self as? T {
            return entity
        } else {
            for child in children {
                if let entity = child.firstEntity(type) {
                    return entity
                }
            }
            return nil
        }
    }

}

extension Sequence where Element: Entity {

    /// Return the first entity in the subtree, if any, for which the condition returns `true`.
    public func firstEntity(where condition: (Entity) -> Bool) -> Entity? {
        for entity in self {
            if let child = entity.firstEntity(where: condition) {
                return child
            }
        }
        return nil
    }

    /// Find and return the first entity of the specified type in the subtree, if any.
    public func firstEntity<T>( _ type: T.Type) -> T? {
        for entity in self {
            if let child = entity.firstEntity(type) {
                return child
            }
        }
        return nil
    }

}
