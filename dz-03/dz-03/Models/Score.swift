//
//  Score.swift
//  dz-03
//
//  Created by Jelena Šarić on 12/06/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation

/// Class which presents score.
class Score: Decodable {
    
    /// User's username.
    let username: String
    /// User's score.
    let score: Double
    
    enum CodingKeys: String, CodingKey {
        case username
        case score
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        username = try container.decode(String.self, forKey: .username)
        self.score = Double(try container.decode(String.self, forKey: .score))!
    }

}
