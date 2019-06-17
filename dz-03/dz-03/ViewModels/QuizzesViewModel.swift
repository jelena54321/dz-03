//
//  QuizzesViewModel.swift
//  dz-02
//
//  Created by Jelena Šarić on 16/05/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation
import Reachability

/// Structure which is used for filling `QuizTableViewCell` with data.
struct QuizCellViewModel {

    /// Quiz id.
    let id: Int
    /// Quiz title.
    let title: String
    /// Quiz description.
    let description: String
    /// Quiz category.
    let category: Category
    /// Quiz level.
    let level: Int
    /// Quiz image.
    let image: String
    /// Dictionary of quiz questions.
    let questions: Set<Question>

    init(quiz: Quiz) {
        self.id = quiz.idValue
        self.title = quiz.title
        self.description = quiz.quizDescription
        self.category = quiz.categoryValue
        self.level = quiz.levelValue
        self.image = quiz.image
        self.questions = quiz.questions
    }
}

/**
 Class which enables communication between model and view controllers.
 This specific class presents quizzes.
 */
class QuizzesViewModel {
    
    /// Quizzes arrays.
    var quizzes: [[Quiz]]?
    
    /// *URL* for checking network reachability.
    private static let reachabilityHostname =  "iosquiz.herokuapp.com"
    
    /**
     Fetches quizzes.
     
     Function works by doing following steps:
     
     1. fetches quizzes from database
     2. checks for network status
     3. finishes fetch process if network status value is equal to `NotReachable`
     4. fetches data from server and updates quizzes in database
     5. finishes fetch process with recently obtained data
     
     - Parameters:
        - onComplete: action which will be executed once fetching is complete
    */
    func fetchQuizzes(onComplete: @escaping (() -> Void)) {
        fetchQuizzesFromDatabase()
        
        let reachability = Reachability(hostName: QuizzesViewModel.reachabilityHostname)
        if reachability?.currentReachabilityStatus() != NetworkStatus.NotReachable {
    
            QuizService.shared.fetchQuizzes { [weak self] _ in
                self?.fetchQuizzesFromDatabase()
            }
        }
        
        onComplete()
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
        guard let quizzes = quizzes else {
            return nil
        }
        
        return QuizViewModel(quiz: quizzes[indexPath.section][indexPath.row])
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
        guard let quizzes = self.quizzes else {
            return nil
        }
        
        return QuizCellViewModel(quiz: quizzes[indexPath.section][indexPath.row])
    }
    
    /**
     Returns number of quizzes associated with specified section.
     
     - Parameters:
        - atIndex: for which section is number of quizzes inquired
     
     - Returns: number of quizzes for provided category.
    */
    func numberOfQuizzes(inSection section: Int) -> Int {
        return quizzes?[section].count ?? 0
    }
    
    /// Returns number of distinct categories.
    func numberOfCategories() -> Int {
        return quizzes?.count ?? 0
    }
    
    /**
     Returns category of specified section.
     
     - Parameters:
        - atIndex: for which section is category acquired
     
     - Returns: category for provided section
     */
    func category(atIndex index: Int) -> Category? {
        guard let quizzes = self.quizzes else {
            return nil
        }
        
        return quizzes[index].first?.categoryValue
    }
    
    /// Fetches quizzes from database.
    private func fetchQuizzesFromDatabase() {
        if let quizzes = DataController.shared.fetchQuizzes() {
            self.quizzes = QuizzesViewModel.groupQuizzesByCategory(quizzes: quizzes)
        }
    }
    
    /**
     Groups provided `Quiz` array into array of `Quiz` arrays where all
     `Quiz` objects in same array share same quiz category.
     
     - Parameters:
        - quizzes: `Quiz` array which whill be grouped
     
     - Returns: a new array of `Quiz` arrays grouped by quiz category
     */
    static func groupQuizzesByCategory(quizzes: [Quiz]) -> [[Quiz]] {
        let categoryDictionary = Dictionary.init(
            grouping: quizzes)
        { (quiz) -> Category in
            quiz.categoryValue
        }
        return Array(categoryDictionary.values)
    }
}
