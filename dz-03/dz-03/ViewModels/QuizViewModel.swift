//
//  SingleQuizViewModel.swift
//  dz-02
//
//  Created by Jelena Šarić on 17/05/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation

/**
 Class which presents communication between `QuizViewController` and
 model.
 */
class QuizViewModel {
    
    private var quiz: Quiz?
    
    init(quiz: Quiz) {
        self.quiz = quiz
    }
    
    /// Quiz id.
    var quizId: Int? {
        return quiz?.idValue
    }
    
    /// Quiz title.
    var quizTitle: String {
        return quiz?.title ?? ""
    }
    
    /// Quiz description.
    var quizDescription: String {
        return quiz?.quizDescription ?? ""
    }
    
    /// Quiz category.
    var quizCategory: Category? {
        return quiz?.categoryValue
    }
    
    /// Quiz level.
    var quizLevel: Int? {
        return quiz?.levelValue
    }
    
    /// Quiz image URL.
    var quizImageURL: URL? {
        if let quizImage = quiz?.image {
            return URL(string: quizImage)
        }
        return nil
    }
    
    /// Quiz questions.
    var quizQuestions: Set<Question> {
        return quiz?.questions ?? Set<Question>()
    }
    
    /**
     Posts quiz results to server.
     
     - Parameters:
        - time: total quiz time
        - noOfCorrect: number of correct answers
        - onComplete: action which will be executed once post has been finished
    */
    func postQuizResults(time: Double, noOfCorrect: Int, onComplete: @escaping ((HttpAnswer?) -> Void)) {
        guard let quizId = quizId else {
            return
        }
        
        ResultService.shared.postQuizResults(
            quizId: quizId,
            time: time,
            noOfCorrect: noOfCorrect
        ) { (httpAnswer) in
            onComplete(httpAnswer)
        }
    }

}
