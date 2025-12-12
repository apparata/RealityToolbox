import Foundation
import RealityKit

extension Entity {

    /// Find and return any entities in the subtree for which the condition returns `true`.
    public func allEntities(where condition: (Entity) -> Bool) -> [Entity] {
        [self].filter { condition($0) } + children.flatMap { child in
            child.allEntities(where: condition)
        }
    }

    /// Find and return any entities of specified type in the subtree.
    public func allEntities<T>(_ type: T.Type) -> [T] {
        [self].compactMap { $0 as? T } + children.flatMap { child in
            child.allEntities(type)
        }
    }

    /// Perform action recursively for all entities in the subtree.
    public func performForAllEntities(_ action: (Entity) -> Void) {
        action(self)
        children.forEach {
            $0.performForAllEntities(action)
        }
    }
}

extension Sequence where Element: Entity {

    /// Find and return any entities in the subtree for which the condition returns `true`.
    public func allEntities(where condition: (Entity) -> Bool) -> [Entity] {
        flatMap { entity in
            entity.allEntities(where: condition)
        }
    }

    /// Find and return any entities of specified type in the subtree.
    public func allEntities<T>(_ type: T.Type) -> [T] {
        flatMap { child in
            child.allEntities(type)
        }
    }
    
}
