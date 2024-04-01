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

}
