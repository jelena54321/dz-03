//
//  QuizzesTableViewSectionHeader.swift
//  dz-02
//
//  Created by Jelena Šarić on 17/05/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import UIKit

/// Class which presents section header in table view.
class QuizzesTableViewSectionHeader: UIView {
    
    /// Title label.
    private let titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpGUI()
    }
    
    /**
     Initializes `QuizzesTableViewSectionHeader` which presents
     category provided as argument.
     
     - Parameters:
        - category: category which this section header presents
     
     - Returns: a new `QuizzesTableViewSectionHeader` object
    */
    convenience init(category: Category) {
        self.init()
        backgroundColor = category.color
        titleLabel.text = category.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    /// Sets up graphic user interface.
    private func setUpGUI() {
        self.addSubview(titleLabel)
        titleLabel.font = UIFont(name: "Avenir-Book", size: 18.0)
        
        titleLabel.autoPinEdge(.leading, to: .leading, of: self, withOffset: 10.0)
        titleLabel.autoPinEdge(.trailing, to: .trailing, of: self)
        titleLabel.autoSetDimension(.height, toSize: 20.0)
        titleLabel.autoAlignAxis(.horizontal, toSameAxisOf: self)
    }
}
