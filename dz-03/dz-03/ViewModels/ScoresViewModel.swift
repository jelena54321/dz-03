//
//  ResultsViewModel.swift
//  dz-03
//
//  Created by Jelena Šarić on 13/06/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation

/// Structure which is used for filling `ScoreTableViewCell` with data.
struct ScoreCellViewModel {
    
    /// User's username.
    let username: String
    /// Score value.
    let score: Double
    
    init(score: Score) {
        self.username = score.username
        self.score = score.score
    }
    
}

/**
 Class which enables communication between model and view controllers.
 This specific class presents scores.
 */
class ScoresViewModel {
    
    /// Scores.
    private var scores: [Score]?
    /// Quiz id.
    private var quizId: Int?
    
    convenience init(quizId: Int) {
        self.init()
        self.quizId = quizId
    }
    
    /**
     Fetches scores and stores them internally.
     
     - Parameters:
        - onComplete: action which will be executed once fetch is complete
    */
    func fetchScores(onComplete: @escaping (() -> Void)) {
        guard let quizId = quizId else {
            return
        }
        
        ResultService.shared.fetchResults(
        quizId: quizId) { [weak self] (scores) in
            self?.scores = scores
            onComplete()
        }
    }
    
    /**
     Returns `ScoreCellViewModel` structure which corresponds `Score` object
     at index specified with argument.
     
     - Parameters:
        - atRow: at which index is quiz inquired
     
     - Returns: structure corresponding to internally stored `Score` object
     at specified position
     */
    func score(atRow index: Int) -> ScoreCellViewModel? {
        guard let scores = scores else {
            return nil
        }
        
        return ScoreCellViewModel(score: scores[index])
    }
    
    /**
     Returns number of internally stored scores.
     
     - Returns: number of `Score` elements stored in an internal array
    */
    func numberOfScores() -> Int {
        return scores?.count ?? 0
    }
}
