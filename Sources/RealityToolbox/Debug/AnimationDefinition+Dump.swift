import Foundation
import RealityKit

// MARK: Dump Anim. Def. Summary

extension AnimationDefinition {

    public func dump() {
        dumpAnimationDefinition(self)
    }

    public func dumpSummary() {
        dumpAnimationDefinitionSummary(self)
    }
}

private func dumpAnimationDefinitionSummary(_ definition: AnimationDefinition, level: Int = 0) {
    let indent = String(repeating: "  ", count: level)
    switch definition {
    case let group as AnimationGroup:
        print("\(indent)AnimationGroup (\(group.group.count))")
        for subdefinition in group.group {
            dumpAnimationDefinitionSummary(subdefinition, level: level + 1)
        }
    case let view as AnimationView:
        print("\(indent)AnimationView")
        if let source = view.source {
            dumpAnimationDefinitionSummary(source, level: level + 1)
        }
    case let animation as SampledAnimation<JointTransforms>:
        _ = animation
        print("\(indent)SampledAnimation<JointTransforms>")
    default:
        print("\(indent)Unknown, aborting...")
    }
}

// MARK: AnimationDefinition Dump

func dumpAnimationDefinition(_ definition: AnimationDefinition) {
    switch definition {
    case let group as AnimationGroup:
        group.dump()
    case let view as AnimationView:
        view.dump()
    case let sampledAnimation as SampledAnimation<JointTransforms>:
        sampledAnimation.dump()
    default:
        print("Undumpable animation definition.")
    }
}

// MARK: AnimationGroup Dump

extension AnimationGroup {

    public func dump() {
        dump(level: 0)
    }

    func dump(level: Int) {
        let indent = String(repeating: "  ", count: level)

        print("\(indent)--- ANIMATION GROUP ---")
        print("\(indent)Name: \(name)")
        print("\(indent)Bind Target: \(bindTarget)")
        print("\(indent)Blend Layer: \(blendLayer)")
        print("\(indent)Additive: \(additive)")

        print("\(indent)Speed: \(speed)")
        print("\(indent)Delay: \(delay)")
        print("\(indent)Duration: \(duration)")
        print("\(indent)Offset: \(offset)")
        print("\(indent)Trim Duration: \(trimDuration ?? 0)")
        print("\(indent)Trim Start: \(trimStart ?? 0)")
        print("\(indent)Trim End: \(trimEnd ?? 0)")

        print("\(indent)Repeat Mode: \(repeatMode)")
        print("\(indent)Fill Mode: \(fillMode)")

        print("\(indent)Children:")
        print("\(indent)--------------------")
        for animationDefinition in group {
            guard let animationView = animationDefinition as? AnimationView else {
                continue
            }
            animationView.dump(level: level + 1)
        }
        print("\(indent)--------------------")
    }
}

// MARK: AnimationView Dump

extension AnimationView {

    public func dump() {
        dump(level: 0)
    }

    func dump(level: Int) {
        let indent = String(repeating: "  ", count: level)

        print("\(indent)--- ANIMATION VIEW ---")

        print("\(indent)Name: \(name)")
        print("\(indent)Bind Target: \(bindTarget)")
        print("\(indent)Blend Layer: \(blendLayer)")

        print("\(indent)Speed: \(speed)")
        print("\(indent)Delay: \(delay)")
        print("\(indent)Duration: \(duration)")
        print("\(indent)Offset: \(offset)")
        print("\(indent)Trim Duration: \(trimDuration ?? 0)")
        print("\(indent)Trim Start: \(trimStart ?? 0)")
        print("\(indent)Trim End: \(trimEnd ?? 0)")

        print("\(indent)Repeat Mode: \(repeatMode)")
        print("\(indent)Fill Mode: \(fillMode)")

        print("\(indent)Source:")
        print("\(indent)==================================")
        if let source {
            switch source {
            case let group as AnimationGroup:
                group.dump(level: level + 1)
            case let view as AnimationView:
                view.dump(level: level + 1)
            case let animation as SampledAnimation<JointTransforms>:
                animation.dump(level: level + 1)
            default:
                print("\(indent)  - Unknown source")
            }
        }
        print("\(indent)==================================")
    }
}

// MARK: SampledAnimation Dump

extension SampledAnimation where Value == JointTransforms {

    public func dump() {
        dump(level: 0)
    }

    func dump(level: Int) {
        let indent = String(repeating: "  ", count: level)

        print("\(indent)--- SAMPLED ANIMATION ---")
        print("\(indent)Name: \(name)")
        print("\(indent)Bind Target: \(bindTarget)")
        print("\(indent)Blend Layer: \(blendLayer)")
        print("\(indent)Joint Names:")
        for jointName in jointNames {
            print("\(indent) - \(jointName)")
        }
        print("\(indent)Is Rotation Animated: \(isRotationAnimated)")
        print("\(indent)Is Scale Animated: \(isScaleAnimated)")
        print("\(indent)Is Translation Animated: \(isTranslationAnimated)")
        print("\(indent)Additive: \(additive)")
        print("\(indent)Tween Mode: \(tweenMode)")

        print("\(indent)Frame Interval: \(frameInterval)")
        print("\(indent)Start: \(start)")
        print("\(indent)End: \(end)")
        print("\(indent)Speed: \(speed)")
        print("\(indent)Delay: \(delay)")
        print("\(indent)Duration: \(duration)")
        print("\(indent)Offset: \(offset)")
        print("\(indent)Trim Duration: \(trimDuration ?? 0)")
        print("\(indent)Trim Start: \(trimStart ?? 0)")
        print("\(indent)Trim End: \(trimEnd ?? 0)")
        print("\(indent)Repeat Mode: \(repeatMode)")
        print("\(indent)Fill Mode: \(fillMode)")

        print("\(indent)Frame count: \(frames.count)")
        /*
         print("\(indent)Frames (Joint Transforms):")
         for (frame, jointTransforms) in frames.enumerated() {
         print("\(indent) - Frame \(frame):")
         for transform in jointTransforms {
         print(transform)
         }
         }*/
    }
}
