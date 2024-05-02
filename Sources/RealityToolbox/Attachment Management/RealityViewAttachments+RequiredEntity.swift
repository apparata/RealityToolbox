#if os(visionOS)

import Foundation
import RealityKit
import SwiftUI

extension RealityViewAttachments {

    /// Gets the identified attachment view as an entity, if the view with that
    /// identifier exists, or crashes with a fatal error.
    ///
    /// Note: Attachment entities are not automatically added to your
    /// ``RealityView``'s content. To display an attachment, add it to your
    /// ``RealityView``'s content using a function like
    /// ``RealityViewContent/add(_:)``.
    ///
    /// - Parameter id: The value that you used to tag the view when you
    ///   define it in the `attachments` parameter of the ``RealityView``
    ///   initializer ``RealityView/init(make:update:attachments:)``.
    /// - Returns: The resolved attachment entity, or fatalErrors if ``RealityView``
    ///   can't find an attachment view with the given `id`.
    public func requiredEntity(for id: some Hashable) -> ViewAttachmentEntity? {
        guard let attachmentEntity = entity(for: id) else {
            fatalError("Required ViewAttachmentEntity \(id) cannot be found.")
        }
        return attachmentEntity
    }
}

#endif
