//
//  MainCoordinator.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 5.6.23.
//

import UIKit

protocol MainCoordinatorType: AnyObject {
    
    var rootViewController: UIViewController? { get }
    func start()
    
    // MARK: Navigation
    func openDetails(_ movie: MovieModel)
}

class MainCoordinator: MainCoordinatorType {
    
    // MARK: - Properties
    unowned var assembler: Assembler
    private var navigationController: UINavigationController?
    
    var rootViewController: UIViewController? {
        navigationController
    }
    
    // MARK: - Construct
    init(assembler: Assembler) {
        self.assembler = assembler
    }
    
    // MARK: - Start
    func start() {
        let rootChild: MoviesListViewController = assembler.resolve(viewModel: assembler.resolve(coordinator: self))
        navigationController = UINavigationController(rootViewController: rootChild)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Styles.Color.blackOpaque80Color
        appearance.titleTextAttributes =  [.foregroundColor: Styles.Color.white]
        navigationController?.navigationBar.tintColor = Styles.Color.white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    }
    
    // MARK: - Navigation
    func openDetails(_ movie: MovieModel) {
        let viewModel = assembler.resolve(movieModel: movie)
        let viewController = assembler.resolve(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
