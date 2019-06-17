//
//  ScoreTableViewCell.swift
//  dz-03
//
//  Created by Jelena Šarić on 14/06/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import UIKit
import PureLayout

/// Class which presents single `UITableViewCell` in `UITableView`.
class ScoresTableViewCell: UITableViewCell {
    
    /// Label with user's score.
    private let scoreLabel: UILabel = UILabel()
    /// Label with user's username.
    private let usernameLabel: UILabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpGUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Sets up graphic user interface.
    private func setUpGUI() {
        scoreLabel.font = UIFont(name: "Avenir-Book", size: 18.0)
        
        self.addSubview(scoreLabel)
        scoreLabel.autoPinEdge(.leading, to: .leading, of: self, withOffset: 20.0)
        scoreLabel.autoAlignAxis(.horizontal, toSameAxisOf: self)
        scoreLabel.autoSetDimension(.width, toSize: 100.0)
        scoreLabel.autoSetDimension(.height, toSize: 30.0)
        
        usernameLabel.font = UIFont(name: "Avenir-Book", size: 16.0)
        usernameLabel.textColor = UIColor.darkGray
        usernameLabel.numberOfLines = 1
        
        self.addSubview(usernameLabel)
        usernameLabel.autoPinEdge(.leading, to: .trailing, of: scoreLabel, withOffset: 20.0)
        usernameLabel.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -10.0)
        usernameLabel.autoAlignAxis(.horizontal, toSameAxisOf: scoreLabel)
        usernameLabel.autoSetDimension(.height, toSize: 20.0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        scoreLabel.text = ""
        usernameLabel.text = ""
    }
    
    /**
     Fills cell with data from provided `ScoreCellViewModel` structure.
     
     - Parameters:
        - score: structure which presents score with data which will be used for
     filling this cell
     */
    func setUp(withScore score: ScoreCellViewModel) {
        scoreLabel.text = String(format: "%.2f", score.score)
        usernameLabel.text = score.username
    }
}
