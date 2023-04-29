//
//  CashedDay+CoreDataProperties.swift
//  MuscleMate
//
//  Created by aplle on 4/29/23.
//
//

import Foundation
import CoreData


extension CashedDay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CashedDay> {
        return NSFetchRequest<CashedDay>(entityName: "CashedDay")
    }

    @NSManaged public var id: Int16
    @NSManaged public var muscle: NSSet?
    
    public var arrayOfMuscles:[CashedMuscle]{
        let set = muscle as? Set<CashedMuscle> ?? []
        return set.sorted{$0.wrappedMuscle < $1.wrappedMuscle}
    }

}

// MARK: Generated accessors for muscle
extension CashedDay {

    @objc(addMuscleObject:)
    @NSManaged public func addToMuscle(_ value: CashedMuscle)

    @objc(removeMuscleObject:)
    @NSManaged public func removeFromMuscle(_ value: CashedMuscle)

    @objc(addMuscle:)
    @NSManaged public func addToMuscle(_ values: NSSet)

    @objc(removeMuscle:)
    @NSManaged public func removeFromMuscle(_ values: NSSet)

}

extension CashedDay : Identifiable {

}
