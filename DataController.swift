//
//  DataController.swift
//  MuscleMate
//
//  Created by aplle on 4/29/23.
//

import Foundation


import Foundation
import CoreData

class DataController:ObservableObject{
    let container = NSPersistentContainer(name: "DaysDataModel")
    
    init(){
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores{description, error in
            if let error = error{
                print("Core data Failed to load:\(error.localizedDescription)")
            }
        }
    }
}
