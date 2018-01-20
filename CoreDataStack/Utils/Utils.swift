//
//  Utils.swift
//  CoreDataStack
//
//  Created by Ryan Yan on 1/19/18.
//  Copyright © 2018 Jiaqi Yan. All rights reserved.
//

import Foundation

class Utils {
    
    static func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    static func randomNumber(min: Int, max: Int) -> Int{
        return  Int(arc4random_uniform(UInt32(max - min))) + min

    }
    
    static func randomName() -> String{
        return Utils.randomString(length: Utils.randomNumber(min:1, max:10))
    }
    
    static func randomGender() -> Gender{
        return  Utils.randomNumber(min: 0, max: 1) == 1 ? Gender.Female : Gender.Male
    }
}
