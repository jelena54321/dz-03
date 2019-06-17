//
//  TabViewController.swift
//  dz-03
//
//  Created by Jelena Šarić on 11/06/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import UIKit

/// Class which presents tab bar controller.
class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpGUI()
    }
    
    /// Sets up graphic user interface.
    private func setUpGUI() {
        let quizzesViewController = QuizzesViewController(quizzesViewModel: QuizzesViewModel())
        let firstTab = UINavigationController(
            rootViewController: quizzesViewController
        )
        
        quizzesViewController.navigationItem.title = "Quizzes"
        firstTab.tabBarItem = UITabBarItem(title: "Quizzes", image: nil, tag: 0)
        
        let searchViewController = SearchViewController(
            searchQuizzesViewModel: SearchQuizzesViewModel(
                quizzesViewModel: QuizzesViewModel()
            )
        )
        let secondTab = UINavigationController(rootViewController: searchViewController)
        
        searchViewController.navigationItem.title = "Search"
        secondTab.tabBarItem = UITabBarItem(title: "Search", image: nil, tag: 0)
        
        let thirdTab = SettingsViewController()
        thirdTab.tabBarItem = UITabBarItem(title: "Settings", image: nil, tag: 0)
        
        self.viewControllers = [firstTab, secondTab, thirdTab]
    }
    
}
