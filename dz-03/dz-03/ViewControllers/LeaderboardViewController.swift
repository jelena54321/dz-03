//
//  LeaderboardViewController.swift
//  dz-03
//
//  Created by Jelena Šarić on 13/06/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import UIKit

/// Class which presents leaderboard.
class LeaderboardViewController: UIViewController {
    
    /// Cell reuse identifier.
    private static let cellReuseIdentifier = "cellReuseIdentifier"
    
    /// Table view containing scores.
    private let scoresTableView = UITableView()
    /// Close button.
    private let closeButton = UIButton()
    
    /// Scores view model.
    private var scoresViewModel: ScoresViewModel!
    /// Refresh control.
    private var refreshControl: UIRefreshControl!
    
    convenience init(scoresViewModel: ScoresViewModel) {
        self.init()
        self.scoresViewModel = scoresViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpGUI()
        addTargets()
        bindModel()
    }
    
    /**
     Defines action which will be performed once *close* button
     has been tapped.
    */
    @objc func closeButtonTapped() {
        self.dismiss(animated: true) {}
    }
    
    /// Defines action which will be executed once refresh has been executed.
    @objc func refresh() {
        DispatchQueue.main.async { [weak self] in
            self?.scoresTableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
    
    /// Sets up graphic user interface.
    private func setUpGUI() {
        self.view.backgroundColor = .lightGray
        
        closeButton.titleLabel?.font = UIFont.init(name: "Avenir-Book", size: 25.0)
        closeButton.setTitle("Close", for: .normal)
        closeButton.backgroundColor = UIColor.init(
            red: 56.0/255.0,
            green: 148.0/255.0,
            blue: 1.0,
            alpha: 1.0
        )
        closeButton.setTitleColor(UIColor.white, for: .normal)
        closeButton.layer.cornerRadius = 5.0
        
        self.view.addSubview(closeButton)
        closeButton.autoPinEdge(.top, to: .top, of: self.view, withOffset: 40.0)
        closeButton.autoPinEdge(.trailing, to: .trailing, of: self.view, withOffset: -10.0)
        closeButton.autoSetDimension(.width, toSize: 120.0)
        closeButton.autoSetDimension(.height, toSize: 40.0)
        
        self.view.addSubview(scoresTableView)
        scoresTableView.autoPinEdge(.leading, to: .leading, of: self.view)
        scoresTableView.autoPinEdge(.trailing, to: .trailing, of: self.view)
        scoresTableView.autoPinEdge(.bottom, to: .bottom, of: self.view)
        scoresTableView.autoPinEdge(.top, to: .bottom, of: closeButton, withOffset: 20.0)
        
        setUpTableView()
    }
    
    /// Sets up *scoresTableView* memeber.
    private func setUpTableView() {
        refreshControl = UIRefreshControl()
        scoresTableView.refreshControl = refreshControl
        
        scoresTableView.register(
            ScoresTableViewCell.self,
            forCellReuseIdentifier: LeaderboardViewController.cellReuseIdentifier
        )
        
        scoresTableView.delegate = self
        scoresTableView.dataSource = self
        scoresTableView.separatorStyle = .singleLine
    }
    
    /// Adds targets to views.
    private func addTargets() {
        closeButton.addTarget(
            self,
            action: #selector(LeaderboardViewController.closeButtonTapped),
            for: UIControl.Event.touchUpInside
        )
        
        refreshControl.addTarget(
            self,
            action: #selector(LeaderboardViewController.refresh),
            for: UIControl.Event.valueChanged
        )
    }
    
    /// Binds model to view controller.
    private func bindModel() {
        scoresViewModel.fetchScores { [weak self] in
            self?.refresh()
        }
    }
}

extension LeaderboardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
}

extension LeaderboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = scoresTableView.dequeueReusableCell(
            withIdentifier: LeaderboardViewController.cellReuseIdentifier,
            for: indexPath
        ) as! ScoresTableViewCell
        
        if let score = scoresViewModel.score(atRow: indexPath.row) {
            cell.setUp(withScore: score)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoresViewModel.numberOfScores()
    }
}
