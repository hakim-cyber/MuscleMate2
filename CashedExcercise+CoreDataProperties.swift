//
//  CashedExcercise+CoreDataProperties.swift
//  MuscleMate
//
//  Created by aplle on 4/29/23.
//
//

import Foundation
import CoreData


extension CashedExcercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CashedExcercise> {
        return NSFetchRequest<CashedExcercise>(entityName: "CashedExcercise")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var repeatsCount: Int16
    @NSManaged public var setsCount: Int16
    @NSManaged public var muscle: CashedMuscle?
    @NSManaged public var bodyPart: String?
    @NSManaged public var equipment: String?
    @NSManaged public var gifUrl: String?
    @NSManaged public var target: String?
    
    
    public var wrappedName:String{
        name ?? "Unknown"
    }
    public var wrappedBodyPart:String{
        bodyPart ?? "Unknown"
    }
    public var wrappedEquipment:String{
        equipment ?? "Unknown"
    }
    public var wrappedGifUrl:String{
        gifUrl ?? "Unknown"
    }
    public var wrappedTarget:String{
        target ?? "Unknown"
    }
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        
        setPrimitiveValue(Int16(0), forKey: "repeatsCount")
        setPrimitiveValue(Int16(0), forKey: "setsCount")
    }
   
}

extension CashedExcercise : Identifiable {

}
