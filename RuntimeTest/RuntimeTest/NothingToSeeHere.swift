//
//  NothingToSeeHere.swift
//  RuntimeTest
//
//  Created by xubojoy on 2018/1/25.
//  Copyright © 2018年 xubojoy. All rights reserved.
//

import UIKit

public protocol SelfAware: class {
    static func awake()
}

class NothingToSeeHere{
    static func harmlessFunction(){
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass?>.allocate(capacity: typeCount)
        let autoreleaseintTypes = AutoreleasingUnsafeMutablePointer<AnyClass?>(types)
        objc_getClassList(autoreleaseintTypes, Int32(typeCount))
        for index in 0 ..< typeCount {
            (types[index] as? SelfAware.Type)?.awake()
        }
        
        
    }
    

}
