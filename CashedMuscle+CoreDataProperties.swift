//
//  CashedMuscle+CoreDataProperties.swift
//  MuscleMate
//
//  Created by aplle on 4/29/23.
//
//

import Foundation
import CoreData


extension CashedMuscle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CashedMuscle> {
        return NSFetchRequest<CashedMuscle>(entityName: "CashedMuscle")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var muscle: String?
    @NSManaged public var day: CashedDay?
    @NSManaged public var exercise: NSSet?

    
    public var wrappedMuscle:String{
        muscle ?? "Unknown"
    }
    
    public var exerciseArray:[CashedExcercise]{
        let set = exercise as? Set<CashedExcercise> ?? []
        
        return set.sorted{
            $0.wrappedName < $1.wrappedName
        }
    }
}

// MARK: Generated accessors for exercise
extension CashedMuscle {

    @objc(addExerciseObject:)
    @NSManaged public func addToExercise(_ value: CashedExcercise)

    @objc(removeExerciseObject:)
    @NSManaged public func removeFromExercise(_ value: CashedExcercise)

    @objc(addExercise:)
    @NSManaged public func addToExercise(_ values: NSSet)

    @objc(removeExercise:)
    @NSManaged public func removeFromExercise(_ values: NSSet)

}

extension CashedMuscle : Identifiable {

}
