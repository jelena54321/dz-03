//
//  QuizzesTableViewCell.swift
//  dz-02
//
//  Created by Jelena Šarić on 16/05/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import UIKit
import Kingfisher

/// Class which presents single `UITableViewCell` in `UITableView`.
class QuizzesTableViewCell: UITableViewCell {
    
    /// Quiz image view.
    private let quizImageView: UIImageView = UIImageView()
    /// Fields container.
    private let fieldsContainer: UIView = UIView()
    /// Label containing quiz title.
    private let quizTitleLabel: UILabel = UILabel()
    /// Label containing quiz description.
    private let quizDescriptionLabel: UILabel = UILabel()
    /// Custom view container.
    private let customViewContainer: UIView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpGUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpGUI() {
        self.addSubview(quizImageView)
        quizImageView.autoSetDimension(.width, toSize: 100.0)
        quizImageView.autoSetDimension(.height, toSize: 100.0)
        quizImageView.autoAlignAxis(.horizontal, toSameAxisOf: self)
        quizImageView.autoPinEdge(.leading, to: .leading, of: self, withOffset: 10.0)
        
        self.addSubview(fieldsContainer)
        fieldsContainer.autoAlignAxis(.horizontal, toSameAxisOf: self)
        fieldsContainer.autoSetDimension(.height, toSize: 80.0)
        fieldsContainer.autoPinEdge(.leading, to: .trailing, of: quizImageView, withOffset: 10.0)
        fieldsContainer.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -10.0)
        
        quizTitleLabel.numberOfLines = 1
        quizTitleLabel.font = UIFont(name: "Avenir-Book", size: 16.0)
        quizTitleLabel.adjustsFontSizeToFitWidth = true
        
        self.addSubview(quizTitleLabel)
        quizTitleLabel.autoPinEdge(.top, to: .top, of: fieldsContainer)
        quizTitleLabel.autoPinEdge(.leading, to: .leading, of: fieldsContainer)
        quizTitleLabel.autoPinEdge(.trailing, to: .trailing, of: fieldsContainer)
        quizTitleLabel.autoSetDimension(.height, toSize: 25.0)
        
        quizDescriptionLabel.numberOfLines = 0
        quizDescriptionLabel.font = UIFont(name: "Avenir-Book", size: 14.0)
        quizDescriptionLabel.textColor = UIColor.darkGray
        
        self.addSubview(quizDescriptionLabel)
        quizDescriptionLabel.autoPinEdge(.bottom, to: .bottom, of: fieldsContainer)
        quizDescriptionLabel.autoPinEdge(.leading, to: .leading, of: fieldsContainer)
        quizDescriptionLabel.autoPinEdge(.trailing, to: .trailing, of: fieldsContainer)
        quizDescriptionLabel.autoSetDimension(.height, toSize: 50.0)
        
        self.addSubview(customViewContainer)
        customViewContainer.autoPinEdge(.trailing, to: .trailing, of: self, withOffset: -10.0)
        customViewContainer.autoPinEdge(.top, to: .top, of: self, withOffset: 10.0)
        customViewContainer.autoSetDimension(.height, toSize: 40.0)
        customViewContainer.autoSetDimension(.width, toSize: 140.0)
        
        let levelIconsView = QuizLevelView()
        customViewContainer.addSubview(levelIconsView)
        levelIconsView.autoPinEdgesToSuperviewEdges()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        quizImageView.image = nil
        quizTitleLabel.text = ""
        quizDescriptionLabel.text = ""
        if let levelView = customViewContainer.subviews.first as? QuizLevelView {
            levelView.level = nil
        }
    }
    
    /**
     Fills cell with data from provided `QuizCellViewModel` structure.
     
     - Parameters:
        - quiz: structure which presents quiz with data which will be used for
     filling this cell
     */
    func setUp(withQuiz quiz: QuizCellViewModel) {
        quizTitleLabel.text = quiz.title
        quizDescriptionLabel.text = quiz.description
        if let levelView = customViewContainer.subviews.first as? QuizLevelView {
            levelView.level = quiz.level
        }
        
        if let imageUrl = URL(string: quiz.image) {
            quizImageView.kf.setImage(with: imageUrl)
        }
    }
    
}
