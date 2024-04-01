import Foundation
import RealityKit

// MARK: Model summary

extension Entity {

    /// Dump debug info about model entities in this entity's subtree to a string.
    func modelSummary() -> String {
        modelSummaryToString(self)
    }
}

private func modelSummaryToString(_ entity: Entity) -> String {
    var string = ""

    if let modelEntity = entity as? ModelEntity {
        string += modelEntitySummaryToString(modelEntity)
    }

    for child in entity.children {
        string += modelSummaryToString(child)
    }

    return string
}

#if !os(visionOS)
private func modelSummaryToString(_ scene: Scene) -> String {
    var string = "Enabled\tEntity\tParts\tTriangles\tMaterials\n"

    for anchor in scene.anchors {
        if let entity = anchor as? AnchorEntity {
            string += modelSummaryToString(entity)
        }
    }
    return string
}
#endif

private func modelEntitySummaryToString(_ entity: ModelEntity) -> String {
    guard let model = entity.model else {
        return ""
    }

    let name = entity.name.count <= 0 ? "[Dynamic]" : "\"\(entity.name)\""

    let meshResource = model.mesh
    let models = meshResource.contents.models

    let materialCount = meshResource.expectedMaterialCount

    var totalPartCount = 0
    var totalTriangleCount = 0

    for model in models {
        totalPartCount += model.parts.count
        for part in model.parts {
            totalTriangleCount += (part.triangleIndices?.count ?? 0) / 3
        }
    }

    return "\(entity.isEnabled ? "🟢" : "⚫️")\t\(name)\t\(totalPartCount)\t\(totalTriangleCount)\t\(materialCount)\n"
}
