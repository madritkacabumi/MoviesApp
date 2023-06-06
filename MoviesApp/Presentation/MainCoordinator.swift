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
        let rootChild: MoviesPresentationViewController = assembler.resolve(viewModel: assembler.resolve(coordinator: self))
        navigationController = UINavigationController(rootViewController: rootChild)
    }
}
