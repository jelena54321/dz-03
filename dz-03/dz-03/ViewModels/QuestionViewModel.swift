//
//  QuestionViewModel.swift
//  dz-02
//
//  Created by Jelena Šarić on 18/05/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation

/**
 Class which presents communication between client and model.
 */
class QuestionViewModel {
    
    private var question: Question?
    
    init(question: Question) {
        self.question = question
    }
    
    /// Question id.
    var questionId: Int? {
        return question?.idValue
    }
    
    /// Question content.
    var questionContent: String {
        return question?.question ?? ""
    }
    
    /// Question answers.
    var questionAnswers: [String] {
        return question?.answers ?? [String]()
    }
    
    /// Correct answer index.
    var correctAnswer: Int? {
        return question?.correctAnswerValue
    }
}
