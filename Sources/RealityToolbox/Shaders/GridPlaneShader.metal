//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

#include <TargetConditionals.h>
#if !TARGET_OS_VISION

#include <metal_stdlib>
#include <RealityKit/RealityKit.h>

using namespace metal;

// MARK: - Grid Plane Surface Shader
//
// This RealityKit surface shader renders a world-space ground grid on the X–Z plane.
//
// Visual features:
// - Decimeter and meter grid lines using modulo math
// - Thicker lines for meter intervals
// - Colored world axes at the origin (X = blue, Z = red)
// - Distance-based fading to reduce aliasing and clutter
//
// The shader writes emissive color and opacity only, so the grid is unaffected
// by scene lighting and can be overlaid cleanly on other content.

[[visible]]
void gridPlane(realitykit::surface_parameters params) {

    float3 position = params.geometry().world_position();

    // Custom parameters supplied by Swift code:
    // properties.xyz → camera world position
    // properties.w   → grid line scale (controls perceived thickness)
    float4 properties = params.uniforms().custom_parameter();
    float3 cameraPosition = properties.xyz;

    // Compute a smooth fade factor based on distance from the camera.
    // Distant grid lines fade out to avoid harsh cutoffs.
    float fade = clamp(distance(position, cameraPosition) / 20, 0.0, 1.0);

    float lineScale = properties.w;
    float dmLineWidth = 0.01 * lineScale;
    float mLineWidth = 0.02 * lineScale;

    // Use modulo arithmetic to create a repeating grid pattern in world space.
    // Values close to zero indicate proximity to a grid line.
    float xDecimeter = abs(fmod(position.x, 0.1));
    float xMeter = abs(fmod(position.x, 1));
    float zDecimeter = abs(fmod(position.z, 0.1));
    float zMeter = abs(fmod(position.z, 1));

    // Convert distances into binary line masks.
    // A value of 1 indicates the fragment lies on a grid line.
    float xDecimeterLine = step(xDecimeter, dmLineWidth);
    float xMeterLine = step(xMeter, mLineWidth);
    float zDecimeterLine = step(zDecimeter, dmLineWidth);
    float zMeterLine = step(zMeter, mLineWidth);

    // Assign special colors to the main world axes at the origin.
    // These override the standard grid line color.
    half3 lineColor;
    if (abs(position.x) < mLineWidth) {
        lineColor = mix(half3(0, 0, 1), half3(0.05), 0.95);
    } else if (abs(position.z) < mLineWidth) {
        lineColor = mix(half3(1, 0, 0), half3(0.05), 0.96);
    } else {
        lineColor = half3(0.05);
    }

    half3 background = half3(0.02);

    half3 color;
    float opacity;
    if (xDecimeterLine + zDecimeterLine + xMeterLine + zMeterLine > 0) {
        color = mix(lineColor, background, fade);
        opacity = 1;
    } else {
        color = background;
        opacity = 0;
    }

    // Output emissive color and opacity.
    // Only grid lines are visible; empty cells remain transparent.
    params.surface().set_emissive_color(color);
    params.surface().set_opacity(opacity);
}

#endif
