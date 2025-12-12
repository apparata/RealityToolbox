//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

#if os(macOS) || os(iOS) || os(tvOS)

import Foundation
import Metal
import RealityKit

class Shaders {

    static let shared = Shaders()

    let library: MTLLibrary

    init() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Error creating default metal device.")
        }
        guard let library = try? device.makeDefaultLibrary(bundle: #bundle) else {
            fatalError("Failed to create default shader library.")
        }
        self.library = library
    }
}

#endif
