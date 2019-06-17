//
//  ResultService.swift
//  dz-02
//
//  Created by Jelena Šarić on 18/05/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation

/// Enum which presents *HTTP* answer.
enum HttpAnswer: Int {
    
    /// Token does not exist.
    case UNAUTHORIZED = 401
    /// Provided token is not corresponding to given user.
    case FORBIDDEN = 403
    /// Quiz with provided quiz id does not exist.
    case NOT_FOUND = 404
    /// Sent request is of illegal format.
    case BAD_REQUEST = 400
    /// Success.
    case OK = 200
}

/// Class which provides posting quiz results on server.
class ResultService {
    
    /// `String` representation of *URL* source for posting results.
    private static let postResultsStringUrl: String = "https://iosquiz.herokuapp.com/api/result"
    
    /// `String` representation of *URL* source for fetching results.
    private static let fetchResultsStringUrl: String = "https://iosquiz.herokuapp.com/api/score"
    
    /// Single `ResultService` instance.
    static let shared: ResultService = ResultService()
    
    private init() {}
    
    /**
     Posts quiz results on server with *URL* address represented with default *stringUrl*.
     
     - Parameters:
        - quizId: id for which quiz results are being posted
        - time: total quiz solving time
        - noOfCorrect: number of correctly answered questions
        - onComplete: action which will be executed once post is finished
    */
    func postQuizResults(quizId: Int, time: Double, noOfCorrect: Int, onComplete: @escaping ((HttpAnswer?) -> Void)) {
        
        if let url = URL(string: ResultService.postResultsStringUrl) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )
            request.setValue(
                UserDefaults.standard.string(forKey: "token"),
                forHTTPHeaderField: "Authorization"
            )
            
            let data: [String: Any] = [
                "quiz_id": quizId,
                "user_id": UserDefaults.standard.integer(forKey: "userId"),
                "time": time,
                "no_of_correct": noOfCorrect
            ]
            request.httpBody = try? JSONSerialization.data(
                withJSONObject: data,
                options: []
            )
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                if let httpResponse = response as? HTTPURLResponse {
                    onComplete(HttpAnswer(rawValue: httpResponse.statusCode))
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
     Fetches quiz results from server.
     
     - Parameters:
        - quizId: quiz for which results are inquired
        - onComplete: action which will be executed once fetch is finished
    */
    func fetchResults(quizId: Int, onComplete: @escaping (([Score]?) -> Void)) {
        
        var urlComponents = URLComponents(string: ResultService.fetchResultsStringUrl)
        urlComponents?.queryItems = [
            URLQueryItem(name: "quiz_id", value: String(quizId))
        ]
        
        if let url = urlComponents?.url {
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )
            request.setValue(
                UserDefaults.standard.string(forKey: "token"),
                forHTTPHeaderField: "Authorization"
            )
            
            let dataTask = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
               
                if let data = data {
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        
                        if let scores = self?.parseData(json: json) {
                            onComplete(self?.getBestTwentyScores(scores: scores))
                        } else {
                            onComplete(nil)
                        }
                        
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
     Parses provided *json* object into an array of `Score` objects.
     
     - Parameters:
        - json: *json* representation of a `Score` array
     
     - Returns: an array of `Score` objects if *json* can be interpreted as such,
     `nil` otherwise
    */
    private func parseData(json: Any) -> [Score]? {
        guard let jsonDictionary = json as? [[String: Any]] else {
            return nil
        }
        
        let decoder = JSONDecoder()
        var scores = [Score]()
        for score in jsonDictionary {
            if let data = try? JSONSerialization.data(withJSONObject: score, options: []),
               let decodedScore = try? decoder.decode(Score.self, from: data) {
                
                scores.append(decodedScore)
            }
        }
        
        return scores
    }
    
    /**
     Returns new `Score` array with size of 20 with scores in descending order according
     to *score* member.
     
     - Parameters:
        - scores: array which will be reduced to 20 sorted memebers
     
     - Returns: reduced array of 20 best `Score` elements according to *score* member
    */
    private func getBestTwentyScores(scores: [Score]) -> [Score] {
        let sortedScores = scores.sorted { (firstScore, secondScore) -> Bool in
            firstScore.score > secondScore.score
        }
        
        return Array(sortedScores.prefix(20))
    }
}
