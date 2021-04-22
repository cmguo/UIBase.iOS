//
//  ViewModel.swift
//  demo
//
//  Created by 郭春茂 on 2021/2/20.
//

import Foundation

class ViewModel: NSObject
{
    
    private var listeners: [(String) -> Void] = []
    
    func listen(_ listener: @escaping (String) -> Void) {
        listeners.append(listener)
    }
    
    func notify(_ name: String) {
        for l in listeners {
            l(name)
        }
    }

}
