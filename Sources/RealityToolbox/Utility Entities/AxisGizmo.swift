//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import Foundation
import RealityKit

/// A 3D axis gizmo composed of X, Y, and Z axis bars with a central pivot sphere.
/// 
/// This entity is useful for visualizing coordinate axes in RealityKit scenes.
public class AxisGizmo: Entity {
    
    /// Creates a new axis gizmo with colored X (red), Y (green), and Z (blue) axes,
    /// along with a white pivot sphere at the origin.
    ///
    /// The axes are constructed using thin box meshes, while the pivot uses a sphere mesh.
    /// All geometry is unlit for consistent visibility.
    public required init() {
        super.init()
        
        let size: Float = 0.3
        let weight: Float = 0.015
        
        // X Axis
        let meshX = MeshResource.generateBox(size: size)
        let materialX = UnlitMaterial(color: NSUIColor.red)
        let modelX = ModelEntity(mesh: meshX, materials: [materialX])
        modelX.transform.translation.x = size / 2
        modelX.transform.scale.y = weight
        modelX.transform.scale.z = weight
        addChild(modelX)
        
        // Y Axis
        let meshY = MeshResource.generateBox(size: size)
        let materialY = UnlitMaterial(color: NSUIColor.green)
        let modelY = ModelEntity(mesh: meshY, materials: [materialY])
        modelY.transform.translation.y = size / 2
        modelY.transform.scale.x = weight
        modelY.transform.scale.z = weight
        addChild(modelY)
        
        // Z Axis
        let meshZ = MeshResource.generateBox(size: size)
        let materialZ = UnlitMaterial(color: NSUIColor.blue)
        let modelZ = ModelEntity(mesh: meshZ, materials: [materialZ])
        modelZ.transform.translation.z = size / 2
        modelZ.transform.scale.x = weight
        modelZ.transform.scale.y = weight
        addChild(modelZ)
        
        // Pivot
        let meshPivot = MeshResource.generateSphere(radius: weight * size)
        let materialPivot = UnlitMaterial(color: NSUIColor.white)
        let modelPivot = ModelEntity(mesh: meshPivot, materials: [materialPivot])
        addChild(modelPivot)
    }
}
