//
//  ImageValueTransformer.swift
//  ExtraNotes
//
//  Created by Nemanja Petrovic on 30/10/2020.
//  Copyright © 2020 Nemanja Petrovic. All rights reserved.
//

import Foundation
import UIKit

// 1. Subclass from `NSSecureUnarchiveFromDataTransformer`
@objc(UIImageValueTransformer)
final class ImageValueTransformer: NSSecureUnarchiveFromDataTransformer {

    /// The name of the transformer. This is the name used to register the transformer using `ValueTransformer.setValueTrandformer(_"forName:)`.
    static let name = NSValueTransformerName(rawValue: String(describing: ImageValueTransformer.self))

    // 2. Make sure `UIImage` is in the allowed class list.
    override static var allowedTopLevelClasses: [AnyClass] {
        return [UIImage.self]
    }

    /// Registers the transformer.
    public static func register() {
        let transformer = ImageValueTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
