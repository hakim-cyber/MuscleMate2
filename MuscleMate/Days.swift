//
//  Days.swift
//  MuscleMate
//
//  Created by aplle on 4/22/23.
//

import Foundation

struct Day:Codable,Identifiable{
    let id:Int
    let muscles:[Muscle]
    
    
}

struct Muscle: Codable,Identifiable{
    var id = UUID()
    let muscle:String
    let exercises:[Exercise]

    
}

struct Exercise:Codable{
    let name:String
    let repeatsCount:Int
    let setsCount:Int
}



