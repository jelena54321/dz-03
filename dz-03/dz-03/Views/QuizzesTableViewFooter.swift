//
//  QuizzesTableViewFooter.swift
//  dz-02
//
//  Created by Jelena Šarić on 17/05/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import Foundation
import UIKit
import PureLayout

/// Class which presents quizzes table view footer.
class QuizzesTableViewFooter: UIView {
    
    /// Logout button.
    private let logoutButton: UIButton = UIButton()
    
    /// Defines action which will be executed once *logout* button is tapped.
    @objc func logutTapped() {
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "token")
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = LoginViewController()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.lightGray
        
        logoutButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 25.0)
        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.setTitleColor(UIColor.white, for: .normal)
        logoutButton.layer.cornerRadius = 5.0
        logoutButton.backgroundColor = UIColor.init(
            red: 56.0/255.0,
            green: 148.0/255.0,
            blue: 1.0,
            alpha: 1.0
        )
        
        self.addSubview(logoutButton)
        logoutButton.autoAlignAxis(.horizontal, toSameAxisOf: self)
        logoutButton.autoAlignAxis(.vertical, toSameAxisOf: self)
        logoutButton.autoSetDimension(.width, toSize: 300.0)
        logoutButton.autoSetDimension(.height, toSize: 40.0)
        
        logoutButton.addTarget(
            self,
            action: #selector(QuizzesTableViewFooter.logutTapped),
            for: UIControl.Event.touchUpInside
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
