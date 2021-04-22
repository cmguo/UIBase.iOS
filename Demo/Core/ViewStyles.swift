//
//  ViewStyles.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/20.
//

import Foundation

class ViewStyles : ViewModel
{
    
    public override class func value(forUndefinedKey key: String) -> Any? {
        return nil
    }
    
    @objc class func valuesForStyle(name: String) -> NSArray? {
        return nil
    }
    

    class func makeValue(_ title: String, _ value: Any) -> NSDictionary.Element {
        return NSDictionary.Element(title, "\(value)")
    }
    
    class func makeValues<T>(enumType: T.Type) -> NSArray where T : CaseIterable, T : RawRepresentable {
        return enumType.allCases.map { (c: T) -> NSDictionary.Element in
            return NSDictionary.Element("\(c)(\(c.rawValue))", "\(c.rawValue)")
        } as NSArray
    }

}
