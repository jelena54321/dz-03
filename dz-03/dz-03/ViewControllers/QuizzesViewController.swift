//
//  QuizzesViewController.swift
//  dz-02
//
//  Created by Jelena Šarić on 15/05/2019.
//  Copyright © 2019 Jelena Šarić. All rights reserved.
//

import UIKit
import PureLayout

/// Class which presents view controller for quizzes table view.
class QuizzesViewController: UIViewController {

    /// Cell reuse identifier.
    private static let cellReuseIdentifier = "cellReuseIdentifier"
    
    /// Table view containing quizzes.
    private let quizzesTableView: UITableView = UITableView()
    /// Table view footer.
    private var tableViewFooter: QuizzesTableViewFooter!
    
    /// Refresh control.
    private var refreshControl: UIRefreshControl!
    /// Quizzes view model.
    private var quizzesViewModel: QuizzesViewModel!
    
    /**
     Initializes view controller with provided `QuizzesViewModel` object.
     View model object presents communication of view controller with model.
     
     - Parameters:
        - quizzesViewModel: `QuizzesViewModel` object reference
     
     - Returns: initialized `QuizzesViewController` object
    */
    convenience init(quizzesViewModel: QuizzesViewModel) {
        self.init()
        self.quizzesViewModel = quizzesViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
        bindViewModel()
    }
    
    /// Defines action which will be executed once refresh has been executed.
    @objc func refresh() {
        DispatchQueue.main.async {
            self.quizzesTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    /// Sets up quizzes table view.
    private func setUpTableView() {
        quizzesTableView.backgroundColor = UIColor.darkGray
        quizzesTableView.delegate = self
        quizzesTableView.dataSource = self
        quizzesTableView.separatorStyle = .singleLine
        
        self.view.addSubview(quizzesTableView)
        quizzesTableView.autoPinEdgesToSuperviewEdges()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector (QuizzesViewController.refresh),
            for: UIControl.Event.valueChanged
        )
        quizzesTableView.refreshControl = refreshControl
        
        quizzesTableView.register(
            QuizzesTableViewCell.self,
            forCellReuseIdentifier: QuizzesViewController.cellReuseIdentifier
        )
        
        tableViewFooter = QuizzesTableViewFooter(
            frame: CGRect(
                origin: CGPoint(x: 0, y: 0),
                size: CGSize(width: self.view.bounds.width, height: 70.0)
            )
        )
        quizzesTableView.tableFooterView = tableViewFooter
    }
    
    /// Acquires data through *viewModel* reference and updates *GUI* with fetched data.
    private func bindViewModel() {
        quizzesViewModel.fetchQuizzes { [weak self] in
            self?.refresh()
        }
    }
}

extension QuizzesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let category = quizzesViewModel.category(atIndex: section) {
            return QuizzesTableViewSectionHeader(category: category)
        }
        
        return QuizzesTableViewSectionHeader()
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let viewModel = quizzesViewModel.quizViewModel(atIndex: indexPath) {
            navigationController?.pushViewController(
                QuizViewController(quizViewModel: viewModel),
                animated: true
            )
        }
    }
}

extension QuizzesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = quizzesTableView.dequeueReusableCell(
            withIdentifier: QuizzesViewController.cellReuseIdentifier,
            for: indexPath
        ) as! QuizzesTableViewCell
        
        if let quiz = quizzesViewModel.quiz(atIndexPath: indexPath) {
            cell.setUp(withQuiz: quiz)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return quizzesViewModel.numberOfCategories()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzesViewModel.numberOfQuizzes(inSection: section)
    }
}
