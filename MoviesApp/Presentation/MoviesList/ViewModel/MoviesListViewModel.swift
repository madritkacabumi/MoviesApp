//
//  MoviesListViewModel.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 06.06.23.
//

import Foundation
import Combine
import AlamofireImage

enum MoviesSectionType {
    
    case favorites
    case watched
    case toWatch
    
    var title: String {
        switch self {
        case .favorites:
            return "Favourites"
        case .watched:
            return "Watched"
        case .toWatch:
            return "To watch"
        }
    }
}

struct MoviesSection {
    let sectionType: MoviesSectionType
    let movies: [MovieItemEntity]
}

struct MoviesListViewModel {
    
    // MARK: - I/O
    struct Input {
        let loadPageTrigger: Trigger<Void>
        let openDetailsTrigger: Trigger<Void>
    }
    
    class Output {
        @Published fileprivate var selectedEntity: MovieItemEntity?
        @Published var errorMessage: String? = nil
        @Published var sections: [MoviesSection] = []
        @Published var isValidSelection = false
        let isLoading = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - Properties
    var selectionDisposeBag = DisposeBag()
    let moviesListUseCase: FetchMoviesListUseCaseType
    let favouritesUseCase: FetchFavouritesMoviesUseCaseType
    let fetchImageUseCase: FetchMovieImageUseCaseType
    let coordinator: MainCoordinatorType
    
    // MARK: - Fetch output
    
    /// Transforms the input of the view to the output needed for the view to bind to.
    /// - Parameters:
    ///   - input: input given by view
    ///   - disposeBag: Cancellable bag to store cancellables
    /// - Returns: the Output required for the view to bind
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let output = Output()
        
        input.loadPageTrigger
            .handleValue(callback: { _ in
                output.errorMessage = nil
                output.isLoading.send(true)
                output.selectedEntity = nil
            }).flatMap { _ -> AnyPublisher<[MoviesSection], Never> in
            
            // get movies list publisher
            let moviesListPublisher = moviesListUseCase.getMoviesList()
                .map {
                    // sorting the results
                    return self.sortMovies(movies: $0.results)
                    
                }.handleError(callback: { error in
                    output.errorMessage = error.localizedDescription
                }).catch({ error in
                    return Just([])
                }).eraseToAnyPublisher()
            
            // get favourites publisher
            let favouritesPublisher = favouritesUseCase
                .getFavourites()
                .catch ({ error in
                    return Just(ResponseModelWrapper(results: [])) // empty response as we ignore the error for the favourites
                })
                .map { $0.results }
                .eraseToAnyPublisher()
            
            // zip publishers
            return Publishers.Zip(moviesListPublisher, favouritesPublisher)
                .receive(on: DispatchQueue.global())
                .map({ moviesList, favouritesList in
                    return self.generateSections(moviesList: moviesList, favourites: favouritesList, for: output)
                    
                }).eraseToAnyPublisher()
                
        }.sink(receiveValue: { items in
            output.sections = items
            output.isLoading.send(false)
            
        }).store(in: disposeBag)
        
        input.openDetailsTrigger.sink { _ in
            guard let selectedMovie = output.selectedEntity?._movieModel else {
                return
            }
            coordinator.openDetails(selectedMovie)
        }.store(in: disposeBag)
        
        output.$selectedEntity
            .map { $0 != nil }
        .assign(to: \.isValidSelection, on: output)
        .store(in: disposeBag)
        
        return output
    }
    
    private func generateSections(moviesList: [MovieModel], favourites: [FavouriteMovieModel], for outPut: Output) -> [MoviesSection] {
        
        selectionDisposeBag.clear()
        var sections = [MoviesSection]()
        
        var favouritesEntities = [MovieItemEntity]()
        var watchedEntities = [MovieItemEntity]()
        var toWatchEntities = [MovieItemEntity]()
        
        for movie in moviesList {
            let entity = MovieItemEntity(movie: movie, useCase: self.fetchImageUseCase)
            if favourites.contains(where: { $0.id == movie.id }) {
                favouritesEntities.append(entity)
            }
            movie.isWatched ? watchedEntities.append(entity) : toWatchEntities.append(entity)
            entity
                .isSelected
                .filter { $0 }
                .sink { _ in
                    guard outPut.selectedEntity != entity else {
                        return
                    }
                    outPut.selectedEntity?.isSelected.send(false)
                    outPut.selectedEntity = entity
                }.store(in: selectionDisposeBag)
        }
        
        // build sections
        if !favouritesEntities.isEmpty {
            sections.append(MoviesSection(sectionType: .favorites, movies: favouritesEntities))
        }
        if !watchedEntities.isEmpty {
            sections.append(MoviesSection(sectionType: .watched, movies: watchedEntities))
        }
        
        if !toWatchEntities.isEmpty {
            sections.append(MoviesSection(sectionType: .toWatch, movies: toWatchEntities))
        }
        
        return sections
    }
    
    private func sortMovies(movies: [MovieModel]) -> [MovieModel] {

        return movies.sorted { movie1, movie2 in
            if movie1.rating == movie2.rating {
                return movie1.title < movie2.title
            } else {
               return movie1.rating > movie2.rating
            }
        }
    }
    
}

