//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

#if canImport(AppKit)
import AppKit
typealias NSUIColor = NSColor
#elseif canImport(UIKit)
import UIKit
typealias NSUIColor = UIColor
#endif
