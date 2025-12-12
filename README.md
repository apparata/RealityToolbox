# RealityToolbox

A Swift package providing convenience functionality and extensions for building RealityKit applications on Apple platforms.

## Features

- **Entity Tree Traversal** - Navigate and search through RealityKit entity hierarchies
- **Component Management** - Find, retrieve, and update components on entities
- **Animation Utilities** - Extensions for working with animation playback controllers
- **Transform Utilities** - Convenient access to scene-space transforms
- **Debug Tools** - Comprehensive utilities for visualizing and inspecting entity structures and animations
- **Immersive Space Utilities** - visionOS-specific tools for sky spheres and environment lighting
- **Utility Entities** - Pre-built entities like AxisGizmo for common visualization needs
- **Attachment Management** - Utilities for RealityView attachments (visionOS)
- **Multiplatform Support** - Cross-platform color abstractions

## Requirements

- iOS 15.0+
- macOS 12.0+
- tvOS 15.0+
- visionOS 1.0+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/apparata/RealityToolbox.git", from: "1.0.0")
]
```

Or add it directly in Xcode via File > Add Package Dependencies.

## Usage

### Entity Tree Traversal

Methods for searching and navigating through RealityKit entity hierarchies. Find entities by type, name, or custom conditions, and perform actions across entire entity trees.

```swift
import RealityToolbox

// Find all entities matching a condition
let visibleEntities = rootEntity.allEntities { $0.isEnabled }

// Find all entities of a specific type
let modelEntities: [ModelEntity] = rootEntity.allEntities(ModelEntity.self)

// Perform an action on all entities recursively
rootEntity.performForAllEntities { entity in
    print(entity.name)
}

// Find the first entity of a type
if let firstModel = rootEntity.firstEntity(ModelEntity.self) {
    // Use the model entity
}

// Get a required named entity (crashes if not found)
let player = rootEntity.findRequiredEntity(named: "Player")
```

### Component Management

Utilities for retrieving and modifying components on entities. Includes convenience methods for optional and required component access, in-place updates, and searching ancestor chains for components.

```swift
// Get a component (returns nil if not present)
if let model = entity.componentOfType(ModelComponent.self) {
    // Use model component
}

// Get a required component (crashes if not present)
let transform = entity.requiredComponent(Transform.self)

// Update a component if it exists
entity.updateComponentIfPresent(ModelComponent.self) { component in
    component.mesh = newMesh
}

// Update or create a component
entity.updateComponent(OpacityComponent.self,
    update: { $0.opacity = 0.5 },
    createFirstIfNotPresent: { OpacityComponent(opacity: 0.5) })

// Find an ancestor with a specific component type
if let ancestorWithPhysics = entity.findAncestorWithComponentOfType(PhysicsBodyComponent.self) {
    // Found an ancestor with physics
}
```

### Scene-Space Transforms

Convenient properties for getting and setting entity transforms in world space, without needing to manually convert between local and scene coordinate systems.

```swift
// Get/set entity position in world space
entity.scenePosition = SIMD3(x: 0, y: 1, z: -2)
let worldPosition = entity.scenePosition

// Get/set entity orientation in world space
entity.sceneOrientation = simd_quatf(angle: .pi / 4, axis: [0, 1, 0])
let worldOrientation = entity.sceneOrientation
```

### Animation Completion

An async method on `AnimationPlaybackController` that allows you to await the completion of an animation, making it easy to sequence animations or trigger actions when animations finish.

```swift
// Wait for an animation to complete
let controller = entity.playAnimation(animation)
await controller.completion()
// Animation is now complete, continue with next steps
```

### Debug Tools

Tools for inspecting and debugging RealityKit scenes. Print entity hierarchies to the console, get model summaries with triangle and material counts, and dump detailed animation information.

```swift
// Print entity tree structure to console
rootEntity.printTree()

// Get tree structure as a string
let treeDescription = rootEntity.treeToString()

// Get a summary of model entities (parts, triangles, materials)
let summary = rootEntity.modelSummary()

// Inspect animation definitions
animation.dump()
animation.dumpSummary()
```

### Sky Sphere (visionOS)

A large inverted sphere entity for rendering sky textures in immersive spaces. Useful for creating custom sky backgrounds in visionOS immersive experiences.

```swift
// Add a sky sphere with a texture to a scene
try await SkySphere.add("sky_texture", in: textureBundle, to: rootEntity)

// Create a sky sphere separately
let skySphere = try await SkySphere.make("sky_texture", in: textureBundle)
rootEntity.addChild(skySphere)

// Change the sky texture
try await skySphere.applyTexture("night_sky", in: textureBundle)
```

### Environment Lighting (visionOS)

Utility for adding image-based lighting (IBL) to entities in visionOS immersive spaces. Apply environment maps to control how entities are lit and reflect their surroundings.

```swift
// Add image-based lighting to entities
try await EnvironmentLighting.add("environment", in: bundle, to: rootEntity)
```

### Axis Gizmo

A 3D coordinate axis visualization entity useful for debugging transforms and orientations. Displays X (red), Y (green), and Z (blue) axes with a white sphere at the origin.

```swift
// Create a 3D coordinate axis visualization
let gizmo = AxisGizmo()
rootEntity.addChild(gizmo)
```

### Grid Plane (iOS, macOS, tvOS only)

A plane entity that renders a world-space grid using a custom RealityKit surface shader. Displays decimeter and meter grid lines with distance-based fading.

> **Note:** GridPlane is not available on visionOS.

```swift
// Create a grid plane
let gridPlane = GridPlane()
rootEntity.addChild(gridPlane)

// Update each frame with camera position for distance-based fading
gridPlane.update(scale: 1.0, cameraPosition: cameraPosition)
```

### RealityView Attachments (visionOS)

A convenience method for retrieving attachment entities from a RealityView's attachments collection. Crashes with a descriptive error if the attachment is not found, helping catch configuration issues early.

```swift
// Get a required attachment entity (crashes if not found)
RealityView { content, attachments in
    let labelEntity = attachments.requiredEntity(for: "label")
    rootEntity.addChild(labelEntity)
}
```

## License

BSD Zero Clause License

Copyright (c) 2024 by Apparata AB

See the [LICENSE](LICENSE) file for details.
