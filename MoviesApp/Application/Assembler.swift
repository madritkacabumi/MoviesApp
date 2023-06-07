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
    func resolve() -> FetchMovieImageUseCaseType
    
    // MARK: Presentation
    func resolve() -> MainCoordinatorType
    
    func resolve(coordinator: MainCoordinatorType) -> MoviesListViewModel
    func resolve(viewModel: MoviesListViewModel) -> MoviesListViewController
    
    func resolve(movieModel: MovieModel) -> MovieDetailViewModel
    func resolve(viewModel: MovieDetailViewModel) -> MovieDetailViewController
    
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
    
    func resolve() -> FetchMovieImageUseCaseType {
        return FetchMovieImageUseCase(network: resolve())
    }
    
    // MARK: - Presentation
    func resolve() -> MainCoordinatorType {
        return MainCoordinator(assembler: self)
    }
    
    func resolve(coordinator: MainCoordinatorType) -> MoviesListViewModel {
        return MoviesListViewModel(moviesListUseCase: resolve(),
                                           favouritesUseCase: resolve(),
                                           fetchImageUseCase: resolve(),
                                           coordinator: coordinator)
    }
    
    func resolve(viewModel: MoviesListViewModel) -> MoviesListViewController {
       return MoviesListViewController(viewModel: viewModel)
    }
    
    func resolve(movieModel: MovieModel) -> MovieDetailViewModel {
        return MovieDetailViewModel(movie: movieModel, fetchImageUseCase: resolve())
    }
    
    func resolve(viewModel: MovieDetailViewModel) -> MovieDetailViewController {
        return MovieDetailViewController(viewModel)
    }
}
