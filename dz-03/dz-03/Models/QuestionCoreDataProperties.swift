//
//  Question+CoreDataProperties.swift
//  dz-03
//
//  Created by Jelena Šarić on 16/06/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//
//

import Foundation
import CoreData

/// Class which presents question entity.
extension Question {

    /// Fetch request for this entity.
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question> {
        return NSFetchRequest<Question>(entityName: "Question")
    }

    /// Question's answers.
    @NSManaged public var answers: [String]?
    /// Question's correct answer.
    @NSManaged public var correctAnswer: Int64
    /// Question's id.
    @NSManaged public var id: Int64
    /// Question content.
    @NSManaged public var question: String?
    
    /**
     Property which enables working with *correctAnswer* member value
     as `Int`.
    */
    var correctAnswerValue: Int {
        get { return Int(correctAnswer) }
        set { correctAnswer = Int64(newValue) }
    }
    
    /**
     Property which enables working with *id* member value as `Int.
    */
    var idValue: Int {
        get { return Int(id) }
        set { id = Int64(newValue) }
    }

}
