//
//  Quiz+CoreDataProperties.swift
//  dz-03
//
//  Created by Jelena Šarić on 16/06/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//
//

import Foundation
import CoreData

/// Class which presents quiz entity.
extension Quiz {

    /// Fetch request for all quizzes.
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Quiz> {
        return NSFetchRequest<Quiz>(entityName: "Quiz")
    }
    
    /// Fetch request with quizzes which contain provided expression in title or description.
    @nonobjc public class func fetchRequest(withExpression expression: String) -> NSFetchRequest<Quiz> {
        let request: NSFetchRequest<Quiz> = fetchRequest()
        request.predicate = NSPredicate(
            format: "(title CONTAINS[cd] %@) OR (quizDescription CONTAINS[cd] %@)",
            expression,
            expression
        )
        return request
    }

    /// Quiz category.
    @NSManaged public var category: String
    /// Quiz id.
    @NSManaged public var id: Int64
    /// Quiz image.
    @NSManaged public var image: String
    /// Quiz level.
    @NSManaged public var level: Int64
    /// Quiz description.
    @NSManaged public var quizDescription: String
    /// Quiz title.
    @NSManaged public var title: String
    /// Quiz questions.
    @NSManaged public var questions: Set<Question>
    
    /**
     Property which enables working with *id* member value as `Int`.
     */
    var idValue: Int {
        get { return Int(id) }
        set { id = Int64(newValue) }
    }
    
    /**
     Property which enables working with *level* member value as `Int`.
     */
    var levelValue: Int {
        get { return Int(level) }
        set { level = Int64(newValue) }
    }
    
    /**
     Property which enables working with *category* member value as `Category`.
     */
    var categoryValue: Category {
        get { return Category(rawValue: category)! }
        set { category = newValue.rawValue }
    }

}
