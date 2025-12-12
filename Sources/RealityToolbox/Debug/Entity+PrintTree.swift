import Foundation
import RealityKit

// MARK: Print Entity Tree

extension Entity {

    /// Dump debug information about the entity and its children to the console.
    public func printTree() {
        printEntityTree(self)
    }
}

#if !os(visionOS)
extension Scene {

    /// Dump debug information about the scene and its children to the console.
    public func printTree() {
        printEntityTree(self)
    }
}
#endif

private func printEntityTree(_ entity: Entity, indentationLevel: Int = 0) {
    let indentation = String(repeating: " ", count: indentationLevel * 2)
    let isEnabled = entity.isEnabled ? "" : "[isEnabled=false]]"
    let name = entity.name.count <= 0 ? "" : "\"\(entity.name)\""
    print("\(indentation)- \(type(of: entity)): \(name) \(isEnabled)")

    for child in entity.children {
        printEntityTree(child, indentationLevel: indentationLevel + 1)
    }
}

#if !os(visionOS)
private func printEntityTree(_ scene: Scene) {
    print("- Scene: \(scene.name)")
    for anchor in scene.anchors {
        if let entity = anchor as? AnchorEntity {
            printEntityTree(entity, indentationLevel: 1)
        }
    }
}
#endif
