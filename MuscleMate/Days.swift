//
//  Days.swift
//  MuscleMate
//
//  Created by aplle on 4/22/23.
//

import Foundation

struct Day:Codable,Identifiable{
    let id:Int
    var muscles:[Muscle]
    
    static let saveKey = "Days"
    
}

struct Muscle: Codable,Identifiable{
    var id = UUID()
    let muscle:String
    var exercises:[Exercise]

    
}

struct Exercise:Codable,Identifiable,Equatable{
    var id = UUID()
    let name:String
    let repeatsCount:Int
    let setsCount:Int
}



