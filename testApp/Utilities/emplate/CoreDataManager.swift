//
//  CoreDataManager.swift
//  testApp
//
//  Created by Ammad Tariq on 12/10/2021.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UserDataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
//    private init() {
//        let container = NSPersistentContainer(name: "UserDataModel")
//        container.loadPersistentStores { description, error in
//            if let error = error {
//                fatalError("Unable to load persistent stores: \(error)")
//            }
//        }
//        self.container = container
//    }
}
