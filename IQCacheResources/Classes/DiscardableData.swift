//
//  DiscardableData.swift
//  Pods
//
//  Created by Irshad on 15/07/17.
//
//

import Foundation

open class DiscardableData: NSObject, NSDiscardableContent {
    
    
    private(set) public var data : Data?
    var  accessedCounter : UInt = 0
    
    
    public init(data:Data) {
        
        self.data = data
    }
    
    
    public func beginContentAccess() -> Bool {
        
        if data == nil {
            
            return false
        }
        
        accessedCounter += 1
        return true
    }
    
    public func endContentAccess() {
        
        if accessedCounter > 0 {
            
            accessedCounter -= 1
        }
    }
    
    public func discardContentIfPossible() {
        
        if accessedCounter == 0 {
            
            data = nil
        }
    }
    
    public func isContentDiscarded() -> Bool {
        
        return data == nil ? true : false
        
    }
    
    
}
