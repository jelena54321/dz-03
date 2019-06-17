//
//  QuizService.swift
//  dz-02
//
//  Created by Jelena Šarić on 15/05/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation

/// Class which provides acquiring `Quiz` array from server.
class QuizService {
    
    /// Default `String` representation of *URL* source.
    private static let urlString: String = "https://iosquiz.herokuapp.com/api/quizzes"
    
    /// Single `QuizService` instance.
    static let shared = QuizService()
    
    private init() {}
    
    /**
     Fetches `Quiz` array in *json* format.
     
     - Parameters:
        - onComplete: action which will be executed once fetch is finished
     */
    func fetchQuizzes(onComplete: @escaping (([Quiz]?) -> Void)) {
        if let url = URL(string: QuizService.urlString) {
            
            let request = URLRequest(url: url)
            let dataTask = URLSession.shared.dataTask(with: request) {(data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(
                            with: data,
                            options: []
                        )
                        
                        onComplete(QuizService.parseQuizzes(json: json))
                    } catch {
                        onComplete(nil)
                    }
                    
                } else {
                    onComplete(nil)
                }
            }
            
            dataTask.resume()
        } else {
            onComplete(nil)
        }
    }
    
    /**
     Parses provided *json* object into array of `Quiz` objects.
     
     - Parameters:
        - json: *json* object which represents quizzes
     
     - Returns: a new array of `Quiz` objects if provided data can be interpreted as
     such, otherwise `nil`
     */
    static func parseQuizzes(json: Any) -> [Quiz]? {
        if let jsonDictionary = json as? [String: Any],
           let quizzes = jsonDictionary["quizzes"] as? [Any] {
            
            var quizArray = [Quiz]()
            for data in quizzes {
                if let quizJson = data as? [String: Any],
                   let quiz = Quiz.createFrom(json: quizJson) {
                    
                    quizArray.append(quiz)
                }
            }
            
            return quizArray
        }
        
        return nil
    }
    
}
