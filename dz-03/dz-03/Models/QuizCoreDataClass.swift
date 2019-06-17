//
//  Quiz+CoreDataClass.swift
//  
//
//  Created by Jelena Šarić on 15/06/2019.
//
//

import Foundation
import CoreData

/// Class which presents quiz entity.
@objc(Quiz)
public class Quiz: NSManagedObject {
    
    /**
     Returns `Quiz` object with *id* member value same as provided argument
     value. Function either returns existing `Quiz` object or creates new
     one.
     
     - Parameters:
        - id: with which id is quiz inquired
     
     - Returns: `Quiz` value with *id* value corresponding argument value
    */
    class func firstOrCreate(withId id: Int) -> Quiz? {
        let context = DataController.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<Quiz> = Quiz.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", String(id))
        request.returnsObjectsAsFaults = false
        
        do {
            let quizzes = try context.fetch(request)
            return quizzes.first ?? Quiz(context: context)
        } catch {
            return nil
        }
    }
    
    /**
     Creates `Quiz` object from *json*. Function makes sure
     that new quiz is saved or old quiz with same id value is
     updated in the database.
     
     - Parameters:
        - json: *json* object which will be used as data source
     
     - Returns: corresponding `Quiz` object if provided *json* can be
     interpreted as such, `nil` otherwise
    */
    class func createFrom(json: [String: Any]) -> Quiz? {
        guard
            let id = json["id"] as? Int,
            let title = json["title"] as? String,
            let description = json["description"] as? String,
            let level = json["level"] as? Int,
            let category = json["category"] as? String,
            let image = json["image"] as? String,
            let questions = json["questions"] as? [[String: Any]] else {
            
                return nil
        }
        
        if let quiz = Quiz.firstOrCreate(withId: id) {
            quiz.idValue = id
            quiz.title = title
            quiz.quizDescription = description
            quiz.levelValue = level
            quiz.image = image
            quiz.category = category
            
            if let parsedQuestions = Quiz.parseQuestions(fromJson: questions) {
                quiz.questions = Set(parsedQuestions)
            } else {
                return nil
            }
            
            do {
                try DataController.shared.persistentContainer.viewContext.save()
            } catch {
                return nil
            }
            
            return quiz
        }
        
        return nil
    }
    
    /**
     Parses *json* to corresponding **Question** array.
     
     - Parameters:
        - fromJson: *json* object which will be used as data source
     
     - Returns: corresponding `Question` array
    */
    private class func parseQuestions(fromJson json: [[String: Any]]) -> [Question]? {
        var questions = [Question]()
        for question in json {
            if let unwrappedQuestion = Question.createFrom(json: question) {
                questions.append(unwrappedQuestion)
            } else {
                return nil
            }
        }
        
        return questions
    }

}
