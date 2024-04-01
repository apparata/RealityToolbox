import Foundation
import RealityKit

// MARK: Entity Tree to String

public extension Entity {

    /// Dump debug information about the entity and its children to a string.
    func treeToString() -> String {
        entityTreeToString(self)
    }
}

#if !os(visionOS)
public extension Scene {
    func treeToString() -> String {
        entityTreeToString(self)
    }
}
#endif

private func entityTreeToString(_ entity: Entity, indentationLevel: Int = 0) -> String {
    let indentation = String(repeating: " ", count: indentationLevel * 2)
    let isEnabled = entity.isEnabled ? "" : "[isEnabled=false]"
    let name = entity.name.count <= 0 ? "" : "\"\(entity.name)\""

    var string = "\(indentation)- \(type(of: entity)): \(name) \(isEnabled)\n"

    if let modelEntity = entity as? ModelEntity {
        string += modelEntityToString(modelEntity, indentationLevel: indentationLevel + 1)
    }

    for child in entity.children {
        string += entityTreeToString(child, indentationLevel: indentationLevel + 1)
    }

    return string
}

#if !os(visionOS)
private func entityTreeToString(_ scene: Scene) -> String {
    var string = "- Scene: \(scene.name)\n"
    for anchor in scene.anchors {
        if let entity = anchor as? AnchorEntity {
            string += entityTreeToString(entity, indentationLevel: 1)
        }
    }
    return string
}
#endif

private func modelEntityToString(_ entity: ModelEntity, indentationLevel: Int) -> String {
    guard let model = entity.model else {
        return ""
    }

    let indentation = String(repeating: " ", count: indentationLevel * 2)

    let meshResource = model.mesh
    let models = meshResource.contents.models

    var string = ""

    for model in models {
        let partCount = model.parts.count
        var totalTriangleCount = 0
        for part in model.parts {
            let triangleCount = (part.triangleIndices?.count ?? 0) / 3
            totalTriangleCount += triangleCount
        }
        string += "\(indentation)- Model: \(partCount) parts, \(totalTriangleCount) tris\n"
    }

    return string
}
