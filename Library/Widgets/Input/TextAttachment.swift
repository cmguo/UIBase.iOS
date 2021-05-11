//
//  TextAttachment.swift
//  Components-Swift
//
//  Created by Dylan on 03/05/2017.
//  Copyright © 2017 liao. All rights reserved.
//

import UIKit

public class ImageTextAttachment: NSTextAttachment {

    private let AltKey = "AltKey"

    @objc public var alt: String?

    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        if let alt = alt {
            aCoder.encode(alt, forKey: AltKey)
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(data: nil, ofType: nil)
        alt = aDecoder.decodeObject(forKey: AltKey) as? String
    }

    init() {
        super.init(data: nil, ofType: nil)
    }
}

public class SegmentTextAttachment: ImageTextAttachment {

    private let AdditionalDataKey = "AdditionalDataKey"

    @objc public var additionalData: Dictionary<String, Any>?

    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        if let data = additionalData {
            aCoder.encode(data, forKey: AdditionalDataKey)
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        additionalData = aDecoder.decodeObject(forKey: AdditionalDataKey) as? Dictionary
    }

    override init() {
        super.init()
    }
}
