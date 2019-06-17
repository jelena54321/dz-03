//
//  Question+CoreDataClass.swift
//  
//
//  Created by Jelena Šarić on 15/06/2019.
//
//

import Foundation
import CoreData

/// Class which presents question entity.
@objc(Question)
public class Question: NSManagedObject {
    
    /**
     Returns `Question` object with *id* member value same as provided argument
     value. Function either returns existing `Question` object or creates new
     one.
     
     - Parameters:
        - id: with which id is question inquired
     
     - Returns: `Question` value with *id* value corresponding argument value
     */
    class func firstOrCreate(withId id: Int) -> Question? {
        let context = DataController.shared.persistentContainer.viewContext
       
        let request: NSFetchRequest<Question> = Question.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", String(id))
        request.returnsObjectsAsFaults = false
        
        do {
            let questions = try context.fetch(request)
            return questions.first ?? Question(context: context)
        } catch {
            return nil
        }
    }
    
    /**
     Creates `Question` object from *json*. Function makes sure that
     new question is saved or old question with same id value is
     updated in the database.
     
     - Parameters:
        - json: *json* object which will be used as data source
     
     - Returns: corresponding `Question` object if provided *json* can be
     interpreted as such, `nil` otherwise
    */
    class func createFrom(json: [String: Any]) -> Question? {
        guard
            let id = json["id"] as? Int,
            let questionString = json["question"] as? String,
            let answers = json["answers"] as? [String],
            let correctAnswer = json["correct_answer"] as? Int else {
         
                return nil
        }
        
        if let question = Question.firstOrCreate(withId: id) {
            question.idValue = id
            question.question = questionString
            question.answers = answers
            question.correctAnswerValue = correctAnswer
            
            do {
                try DataController.shared.persistentContainer.viewContext.save()
            } catch {
                return nil
            }
            
            return question
        }
        
        return nil
    }

}
