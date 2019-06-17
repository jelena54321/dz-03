//
//  SearchViewController.swift
//  dz-03
//
//  Created by Jelena Šarić on 16/06/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import UIKit

/// Class which presents search view controller.
class SearchViewController: UIViewController {
    
    /// Cell reuse identifier.
    private static let cellReuseIdentifier = "cellReuseIdentifier"
    
    /// Search text field.
    private let searchField: UITextField = UITextField()
    /// Search button.
    private let searchButton: UIButton = UIButton()
    /// Searched quizzes table view.
    private let quizzesTableView: UITableView = UITableView()
    
    /// Refresh control.
    private var refreshControl: UIRefreshControl!
    /// Search quizzes view model.
    private var searchQuizzesViewModel: SearchQuizzesViewModel!
    
    /**
     Initializes view controller with provided `SearchQuizzesViewModel` object.
     View model object presents communication of view controller with model.
     
     - Parameters:
        - searchQuizzesViewModel: `SearchQuizzesViewModel` object reference
     
     - Returns: initialized `SearchViewController` object
     */
    convenience init(searchQuizzesViewModel: SearchQuizzesViewModel) {
        self.init()
        self.searchQuizzesViewModel = searchQuizzesViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpGUI()
        addTargets()
    }
    
    /// Defines action which will be executed once refresh has been executed.
    @objc func refresh() {
        DispatchQueue.main.async { [weak self] in
            self?.quizzesTableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
    
    /// Defines action which will be executed once *Search* has been tapped.
    @objc func searchTapped() {
        guard let expression = searchField.text else {
            return
        }
        
        searchQuizzesViewModel.fetchQuizzes(withExpession: expression) { [weak self] in
            self?.quizzesTableView.isHidden = false
            self?.refresh()
        }
    }
    
    /// Sets up graphic user interface.
    private func setUpGUI() {
        navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = .white
        
        let defaultFont = UIFont.init(name: "Avenir-Book", size: 25.0)
        
        searchField.font = defaultFont
        searchField.placeholder = "Type..."
        searchField.layer.borderColor = UIColor.lightGray.cgColor
        searchField.layer.borderWidth = 1
        searchField.layer.cornerRadius = 5.0
        searchField.autocapitalizationType = .none
        
        self.view.addSubview(searchField)
        searchField.autoPinEdge(.top, to: .top, of: self.view, withOffset: 30.0)
        searchField.autoPinEdge(.leading, to: .leading, of: self.view, withOffset: 40.0)
        searchField.autoPinEdge(.trailing, to: .trailing, of: self.view, withOffset: -40.0)
        searchField.autoSetDimension(.height, toSize: 40.0)
        
        searchButton.titleLabel?.font = defaultFont
        searchButton.setTitle("Search", for: .normal)
        searchButton.setTitleColor(UIColor.white, for: .normal)
        searchButton.layer.cornerRadius = 5.0
        searchButton.backgroundColor = UIColor.init(
            red: 56.0/255.0,
            green: 148.0/255.0,
            blue: 1.0,
            alpha: 1.0
        )
        
        self.view.addSubview(searchButton)
        searchButton.autoPinEdge(.top, to: .bottom, of: searchField, withOffset: 20.0)
        searchButton.autoPinEdge(.leading, to: .leading, of: searchField)
        searchButton.autoPinEdge(.trailing, to: .trailing, of: searchField)
        searchButton.autoSetDimension(.height, toSize: 40.0)
        
        self.view.addSubview(quizzesTableView)
        quizzesTableView.autoPinEdge(.top, to: .bottom, of: searchButton, withOffset: 20.0)
        quizzesTableView.autoPinEdge(.leading, to: .leading, of: self.view)
        quizzesTableView.autoPinEdge(.trailing, to: .trailing, of: self.view)
        quizzesTableView.autoPinEdge(.bottom, to: .bottom, of: self.view)
        
        setUpTableView()
    }
    
    /// Sets up table view.
    private func setUpTableView() {
        quizzesTableView.isHidden = true
        
        refreshControl = UIRefreshControl()
        quizzesTableView.refreshControl = refreshControl
        
        quizzesTableView.register(
            QuizzesTableViewCell.self,
            forCellReuseIdentifier: SearchViewController.cellReuseIdentifier
        )
        
        quizzesTableView.delegate = self
        quizzesTableView.dataSource = self
        quizzesTableView.separatorStyle = .singleLine
    }
    
    /// Adds targets to views.
    private func addTargets() {
        searchButton.addTarget(
            self,
            action: #selector(SearchViewController.searchTapped),
            for: UIControl.Event.touchUpInside
        )
        
        refreshControl.addTarget(
            self,
            action: #selector(SearchViewController.refresh),
            for: UIControl.Event.valueChanged
        )
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let category = searchQuizzesViewModel.category(atIndex: section) {
            return QuizzesTableViewSectionHeader(category: category)
        }
        
        return QuizzesTableViewSectionHeader()
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let viewModel = searchQuizzesViewModel.quizViewModel(atIndex: indexPath) {
            navigationController?.pushViewController(
                QuizViewController(quizViewModel: viewModel),
                animated: true
            )
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = quizzesTableView.dequeueReusableCell(
            withIdentifier: SearchViewController.cellReuseIdentifier,
            for: indexPath
            ) as! QuizzesTableViewCell
        
        if let quiz = searchQuizzesViewModel.quiz(atIndexPath: indexPath) {
            cell.setUp(withQuiz: quiz)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchQuizzesViewModel.numberOfCategories()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchQuizzesViewModel.numberOfQuizzes(inSection: section)
    }
}
