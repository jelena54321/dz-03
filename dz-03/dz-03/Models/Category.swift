//
//  Category.swift
//  dz-02
//
//  Created by Jelena Šarić on 15/05/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation
import UIKit

/// Enum which represents available Quiz categories.
enum Category: String, Decodable {
    
    case sports = "SPORTS"
    case science = "SCIENCE"
    
    /// Color representation of category.
    var color: UIColor {
        switch self {
        case .sports:
            return UIColor.blue
        case .science:
            return UIColor.green
        }
    }
}
