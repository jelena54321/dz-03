//
//  LoginService.swift
//  dz-02
//
//  Created by Jelena Šarić on 09/05/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation

/// Class which provides session establishment with server.
class LoginService {
    
    /// Default `String` representation of *URL* source.
    private static let stringUrl: String = "https://iosquiz.herokuapp.com/api/session"
    
    /// Single `LoginService` instance.
    static let shared: LoginService = LoginService()
    
    private init() {}
    
    /**
     Establishes session with server by using provided *username* and *password* as
     parameters. Default *stringUrl* is used as string representation of source address.
     
     - Parameters:
        - username: username which will be used for session establishment
        - password: password which will be used for session establishment
        - onComplete: action which will be executed once fetch is finished
     */
    func establishSession(username: String, password: String, onComplete: @escaping ((Int?, String?) -> Void)) {
        
        if let url = URL(string: LoginService.stringUrl) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )
            
            let data = [
                "username": username,
                "password": password
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: data, options: [])
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(
                            with: data,
                            options: []
                        )
                    
                        if let (userId, token) = LoginService.parseJson(json: json) {
                            onComplete(userId, token)
                        } else {
                            onComplete(nil, nil)
                        }
                        
                    } catch {
                        onComplete(nil, nil)
                    }
                    
                } else {
                    onComplete(nil, nil)
                }
            }
            
            dataTask.resume()
        } else {
            onComplete(nil, nil)
        }
    }
    
    /**
     Parses provided *json* as *integer* associated with key *user_id* and *string*
     associated with key *token*
     
     - Parameters:
        - json: *json* object which represents user id and access token
     
     - Returns: `Integer` and `String` tuple stored in *json* object if such items exist,
     otherwise `nil`
     
     */
    private static func parseJson(json: Any) -> (Int, String)? {
        if let jsonDictionary = json as? [String: Any],
           let userId = jsonDictionary["user_id"] as? Int,
           let token = jsonDictionary["token"] as? String {
           
            return (userId, token)
        }
    
        return nil
    }
    
}
