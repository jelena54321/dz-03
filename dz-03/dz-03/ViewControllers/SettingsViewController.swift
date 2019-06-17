//
//  SettingsViewController.swift
//  dz-03
//
//  Created by Jelena Šarić on 14/06/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import UIKit

/// Class which presents settings view controller.
class SettingsViewController: UIViewController {
    
    /// Views container.
    private let viewsContainer: UIView = UIView()
    /// Label with user's username.
    private let usernameLabel: UILabel = UILabel()
    /// Logout button.
    private let logoutButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpGUI()
        addTargets()
    }
    
    /**
     Defines action which will be executed once *logoutButton* has
     been tapped.
    */
    @objc func logoutTapped() {
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "token")
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = LoginViewController()
    }
    
    /// Sets up graphic user interface.
    private func setUpGUI() {
        self.view.backgroundColor = .white
        
        let defaultFont = UIFont(name: "Avenir-Book", size: 25.0)
        
        self.view.addSubview(viewsContainer)
        viewsContainer.autoAlignAxis(.horizontal, toSameAxisOf: self.view)
        viewsContainer.autoAlignAxis(.vertical, toSameAxisOf: self.view)
        viewsContainer.autoPinEdge(.leading, to: .leading, of: self.view, withOffset: 40.0)
        viewsContainer.autoPinEdge(.trailing, to: .trailing, of: self.view, withOffset: -40.0)
        
        usernameLabel.text = UserDefaults.standard.string(forKey: "username")
        usernameLabel.font = defaultFont
        usernameLabel.textAlignment = .center
        
        viewsContainer.addSubview(usernameLabel)
        usernameLabel.autoPinEdge(.top, to: .top, of: viewsContainer, withOffset: 20.0)
        usernameLabel.autoPinEdge(.leading, to: .leading, of: viewsContainer)
        usernameLabel.autoPinEdge(.trailing, to: .trailing, of: viewsContainer)
        usernameLabel.autoSetDimension(.height, toSize: 40.0)
        
        logoutButton.titleLabel?.font = defaultFont
        logoutButton.setTitle("Log Out", for: .normal)
        logoutButton.setTitleColor(UIColor.white, for: .normal)
        logoutButton.layer.cornerRadius = 5.0
        logoutButton.backgroundColor = UIColor.init(
            red: 56.0/255.0,
            green: 148.0/255.0,
            blue: 1.0,
            alpha: 1.0
        )
        
        viewsContainer.addSubview(logoutButton)
        logoutButton.autoPinEdge(.top, to: .bottom, of: usernameLabel, withOffset: 20.0)
        logoutButton.autoPinEdge(.leading, to: .leading, of: viewsContainer)
        logoutButton.autoPinEdge(.trailing, to: .trailing, of: viewsContainer)
        logoutButton.autoPinEdge(.bottom, to: .bottom, of: viewsContainer, withOffset: -20.0)
        logoutButton.autoSetDimension(.height, toSize: 40.0)
    }
    
    /// Adds targets to views.
    private func addTargets() {
        logoutButton.addTarget(
            self,
            action: #selector(SettingsViewController.logoutTapped),
            for: UIControl.Event.touchUpInside
        )
    }
}
