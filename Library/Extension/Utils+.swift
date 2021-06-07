//
// Created by Crap on 2021/6/3.
//

import Foundation

/**
 This is a copy from https://stackoverflow.com/questions/25426780/how-to-have-stored-properties-in-swift-the-same-way-i-had-on-objective-c?answertab=votes#tab-top
 */
public final class ObjectAssociation<T> {

    private let policy: objc_AssociationPolicy

    /// - Parameter policy: An association policy that will be used when linking objects.
    public init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        self.policy = policy
    }

    /// Accesses associated object.
    /// - Parameter index: An object whose associated object is to be accessed.
    public subscript(index: AnyObject) -> T? {
        get {
            return objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as! T?
        }
        set {
            objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy)
        }
    }
}

public typealias Runnable = () -> Void
public typealias OnClickListener = (_ view: UIView) -> Void


// load url from bundle, not test yet.
//extension URL {
//    public static func getUrl(resource: String, resourcePath: String) -> URL? {
//        var rootUrl = Bundle.main.url(forResource: resource, withExtension: "bundle")
//        rootUrl?.appendPathComponent(resourcePath)
//        return rootUrl
//    }
//}