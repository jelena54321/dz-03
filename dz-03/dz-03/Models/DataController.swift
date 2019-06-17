//
//  DataController.swift
//  dz-03
//
//  Created by Jelena Šarić on 15/06/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation
import CoreData

/// Class which presents interface for communication with database.
class DataController {
    
    /// Single `DataController` instance.
    static let shared: DataController = DataController()
    
    private init() {}
    
    /**
     Container used for creation and management of *CoreData* object model.
     Complete initialization of *CoreData* stack is provided by loading
     persistent stores.
    */
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(
            completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
        )
        
        return container
    }()
    
    /**
     Fetches `Quiz` array from database.
     
     - Returns: `Quiz` array acquired from database
    */
    func fetchQuizzes() -> [Quiz]? {
        let context = persistentContainer.viewContext
        return try? context.fetch(Quiz.fetchRequest())
    }
    
    /**
     Fetches `Quiz` array with quizzes which satisfy following requirement:
     quiz title or quiz description contains expression provided through
     argument.
     
     - Parameters:
        - expression: expression which must be a part of a title or a quiz description
     
     - Returns: `Quiz` array of quizzes which satisfy perviously mentioned requirement
     */
    func fetchQuizzes(withExpression expression: String) -> [Quiz]? {
        let context = persistentContainer.viewContext
        return try? context.fetch(Quiz.fetchRequest(withExpression: expression))
    }
    
    /// Propagates context changes to database.
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
