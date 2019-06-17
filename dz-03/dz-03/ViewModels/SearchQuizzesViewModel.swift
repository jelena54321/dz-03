//
//  SearchQuizzesViewModel.swift
//  dz-03
//
//  Created by Jelena Šarić on 17/06/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation
import Reachability

/// Class which presents search quizzes model.
class SearchQuizzesViewModel {
    
    /// Quizzes view model.
    private var quizzesViewModel: QuizzesViewModel!
    
    /**
     Initializes `SearchQuizzesViewModel` object with *quizzesViewModel*
     provided as argument.
     
     - Parameters:
        - quizzesViewModel: `QuizzesViewModel` instance
    */
    init(quizzesViewModel: QuizzesViewModel) {
        self.quizzesViewModel = quizzesViewModel
    }
    
    /**
     Fetches `Quiz` array with quizzes which satisfy following requirement and stores
     them internally: quiz title or quiz description contains expression provided through
     argument.
     
     - Parameters:
        - expression: expression which must be a part of a title or a quiz description
        - onComplete: action which will be executed once fetch is complete
     */
    func fetchQuizzes(withExpession expression: String, onComplete: @escaping (() -> Void)) {
        if let quizzes = DataController.shared.fetchQuizzes(withExpression: expression) {
            quizzesViewModel.quizzes = QuizzesViewModel.groupQuizzesByCategory(
                quizzes: quizzes
            )
            
            onComplete()
        }
        
    }
    
    /**
     Returns `QuizViewModel` object corresponding `Quiz` object at index path
     provided with arguent.
     
     - Parameters:
        - indexPath: for which index path is corresponding `SingleQuizViewModel` object
     inquired
     
     - Returns: quiz view model presenting quiz at provided index path.
     */
    func quizViewModel(atIndex indexPath: IndexPath) -> QuizViewModel? {
        return quizzesViewModel.quizViewModel(atIndex: indexPath)
    }
    
    /**
     Returns `QuizCellViewModel` structure which corresponds `Quiz` object
     at index path specified with argument.
     
     - Parameters:
        - atIndexPath: at which index path is quiz inquired
     
     - Returns: structure corresponding to internally stored `Quiz` object
     at specified position
     */
    func quiz(atIndexPath indexPath: IndexPath) -> QuizCellViewModel? {
        return quizzesViewModel.quiz(atIndexPath: indexPath)
    }
    
    /**
     Returns number of quizzes associated with specified section.
     
     - Parameters:
        - atIndex: for which section is number of quizzes inquired
     
     - Returns: number of quizzes for provided category.
     */
    func numberOfQuizzes(inSection section: Int) -> Int {
        return quizzesViewModel.numberOfQuizzes(inSection: section)
    }
    
    /// Returns number of distinct categories.
    func numberOfCategories() -> Int {
        return quizzesViewModel.numberOfCategories()
    }
    
    /**
     Returns category of specified section.
     
     - Parameters:
        - atIndex: for which section is category acquired
     
     - Returns: category for provided section
     */
    func category(atIndex index: Int) -> Category? {
        return quizzesViewModel.category(atIndex: index)
    }
    
}
