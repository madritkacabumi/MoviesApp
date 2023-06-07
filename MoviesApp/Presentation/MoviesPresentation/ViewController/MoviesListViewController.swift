//
//  MoviesPresentationViewController.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 06.06.23.
//

import UIKit

class MoviesListViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: MoviesListViewModel
    let disposeBag = DisposeBag()
    let loadItemsTrigger = Trigger<Void>()
    let openDetailTrigger = Trigger<Void>()
    let tableViewAdapter: MoviesPresentationAdapter
    
    // MARK: - UIViews
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.tintColor = Styles.Color.primaryBlueColor
        return tableView
    }()
    
    lazy var refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action:
                         #selector(handleRefresh),
                         for: .valueChanged)
        refreshControl.tintColor = Styles.Color.primaryBlueColor
        return refreshControl
    }()
    
    lazy var nextButton: UIButton = {
        let button = CustomButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal)
        button.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundColor(Styles.Color.primaryBlueColor, for: .normal)
        button.setBackgroundColor(.lightGray, for: .disabled)
        button.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Construct
    init(viewModel: MoviesListViewModel) {
        self.viewModel = viewModel
        self.tableViewAdapter = MoviesPresentationAdapter()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.bind()
    }
    
    func setupView() {
        
        self.view.backgroundColor = .white
        self.title = "Movies App" // todo localise
        // add button
        self.view.addSubview(nextButton)
        nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nextButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        // add tableview
        self.view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.nextButton.topAnchor, constant: -5).isActive = true
        
        // setup tableview
        tableView.delegate = tableViewAdapter
        tableView.dataSource = tableViewAdapter
        tableViewAdapter.registerCells(for: tableView)
        tableViewAdapter.delegate = self
        
        // add refresh control
        tableView.addSubview(self.refreshControl)
    }
    
    // MARK: - UIActions
    @objc func nextButtonPressed() {
        openDetailTrigger.fire()
    }
    
    @objc func handleRefresh() {
        loadItemsTrigger.fire()
    }
}

// MARK: - Bind
extension MoviesListViewController {
    
    func bind() {
        
        let input = MoviesListViewModel.Input(
            loadPageTrigger: loadItemsTrigger,
            openDetailsTrigger: openDetailTrigger)
        
        let output = viewModel.transform(input, disposeBag: disposeBag)
        
        output.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                isLoading ? self?.refreshControl.beginRefreshing() : self?.refreshControl.endRefreshing()
            }.store(in: disposeBag)
        
        output.$sections
            .receive(on: DispatchQueue.main)
            .assign(to: \.sections, on: tableViewAdapter)
            .store(in: disposeBag)
        
        output.$isValidSelection
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: self.nextButton)
            .store(in: disposeBag)
        
        loadItemsTrigger.fire()
    }
}

extension MoviesListViewController: MoviesPresentationAdapterDelegate {
    
    func reloadData() {
        self.tableView.reloadData()
    }
}
