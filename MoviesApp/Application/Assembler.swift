//
//  Assembler.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 5.6.23.
//

import Foundation
import UIKit
import Alamofire

protocol Assembler: AnyObject {
    
    // MARK: Application
    func resolve() -> NetworkServiceType
    
    //MARK: - UseCases
    func resolve() -> FetchMoviesListUseCaseType
    func resolve() -> FetchFavouritesMoviesUseCaseType
    
    // MARK: Presentation
    func resolve() -> MainCoordinatorType
    func resolve(coordinator: MainCoordinatorType) -> MoviesPresentationViewModel
    func resolve(viewModel: MoviesPresentationViewModel) -> MoviesPresentationViewController
    
}

class DefaultAssembler: Assembler {
    
    // MARK: - Application
    func resolve() -> NetworkServiceType {
        return NetworkService(session: .default)
    }
    
    //MARK: - UseCases
    func resolve() -> FetchMoviesListUseCaseType {
        return FetchMoviesListUseCase(network: resolve())
    }
    
    func resolve() -> FetchFavouritesMoviesUseCaseType {
        return FetchFavouritesMoviesUseCase(network: resolve())
    }
    
    // MARK: - Presentation
    func resolve() -> MainCoordinatorType {
        return MainCoordinator(assembler: self)
    }
    
    func resolve(coordinator: MainCoordinatorType) -> MoviesPresentationViewModel {
        return MoviesPresentationViewModel(moviesListUseCase: resolve(), favouritesUseCase: resolve(), coordinator: coordinator)
    }
    
    func resolve(viewModel: MoviesPresentationViewModel) -> MoviesPresentationViewController {
       return MoviesPresentationViewController(viewModel: viewModel)
    }
}
