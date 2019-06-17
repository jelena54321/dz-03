//
//  QuestionView.swift
//  iOSVjestina2019
//
//  Created by Jelena Šarić on 04/04/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import UIKit
import PureLayout

/// Protocol which defines question view delegates.
protocol QuestionViewDelegate {
    
    /**
     Called when single question has been answered.
     
     - Parameters:
        - questionView: `QuestionView` object on which answer button has been tapped
        - isCorrect: `boolean` value which determines whether answer has been
     answered correctly
    */
    func questionAnswered(questionView: QuestionView, isCorrect: Bool)
}

/// View which represents question with associated answers.
class QuestionView: UIView {
    
    /// Question label.
    private var questionLabel: UILabel = UILabel()
    /// Array of answer buttons.
    private var answerButtons: [UIButton] = [UIButton]()
    /// Question view model.
    private var questionViewModel: QuestionViewModel!
    /// Delegate.
    var delegate: QuestionViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpGUI()
    }
    
    /**
     Initializes `QuestionView` object with *questionViewModel* provided
     as argument.
     
     - Parameters:
        - questionViewModel: `QuestionViewModel` object reference used for communication
     with model
     
     - Returns: a `QuestionView` object
    */
    convenience init(questionViewModel: QuestionViewModel) {
        self.init()
        self.questionViewModel = questionViewModel
        bindQuestion()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    /// Defines action which will be executed once answer button has been tapped.
    @objc private func answerTapped(_ sender: UIButton) {
        guard let correctAnswerIndex = questionViewModel.correctAnswer,
              let tappedButtonInput = sender.currentTitle else {
            return
        }
        
        let correctAnswer = questionViewModel.questionAnswers[correctAnswerIndex]
        let isCorrect = tappedButtonInput == correctAnswer
        if isCorrect {
            sender.backgroundColor = UIColor.green
        }  else {
            sender.backgroundColor = UIColor.red
        }
        
        delegate?.questionAnswered(questionView: self, isCorrect: isCorrect)
    }
    
    /// Sets up graphic user interface.
    private func setUpGUI() {
        let defaultFont = UIFont.init(name: "Avenir-Book", size: 18.0)
        
        questionLabel.backgroundColor = UIColor.darkGray
        questionLabel.font = defaultFont
        questionLabel.numberOfLines = 0
        questionLabel.textColor = UIColor.white
        questionLabel.textAlignment = NSTextAlignment.center
        
        self.addSubview(questionLabel)
        questionLabel.autoPinEdge(.top, to: .top, of: self)
        questionLabel.autoPinEdge(.leading, to: .leading, of: self)
        questionLabel.autoPinEdge(.trailing, to: .trailing, of: self)
        questionLabel.autoSetDimension(.height, toSize: 80.0)
        
        var upperView: UIView = questionLabel
        for i in 0...3 {
            let button = UIButton()
            button.backgroundColor = UIColor.lightGray
            button.titleLabel?.font = defaultFont
            button.setTitleColor(UIColor.white, for: .normal)
            button.addTarget(
                self,
                action: #selector(QuestionView.answerTapped),
                for: UIControl.Event.touchUpInside
            )
            
            answerButtons.append(button)
            self.addSubview(button)
            
            button.autoPinEdge(.leading, to: .leading, of: self)
            button.autoPinEdge(.trailing, to: .trailing, of: self)
            button.autoSetDimension(.height, toSize: 40.0)
            
            if i == 0 {
                button.autoPinEdge(.top, to: .bottom, of: upperView, withOffset: 5.0)
            } else {
                button.autoPinEdge(.top, to: .bottom, of: upperView, withOffset: 2.0)
            }
            
            if i == 3 {
                button.autoPinEdge(.bottom, to: .bottom, of: self)
            }
            
            upperView = button
        }
    }
    
    /// Binds *question* to view.
    private func bindQuestion() {
        questionLabel.text = questionViewModel.questionContent
        for i in 0..<answerButtons.count {
            answerButtons[i].setTitle(questionViewModel.questionAnswers[i], for: .normal)
        }
    }
    
}
