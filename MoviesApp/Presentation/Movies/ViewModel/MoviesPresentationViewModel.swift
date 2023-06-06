//
//  MoviesPresentationViewModel.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 06.06.23.
//

import Foundation
import Combine

enum MoviePresentationSectionType {
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

struct MoviePresentationSection {
    let presentationType: MoviePresentationSectionType
    let movies: [MovieItemEntity]
}

// move to cell
struct MovieItemEntity {
    
    private var movie: MovieModel
    
    init(movie: MovieModel) {
        self.movie = movie
    }
}

struct MoviesPresentationViewModel {
    
    // MARK: - I/O
    struct Input {
        let loadPageTrigger: Trigger<Void>
    }
    
    class Output {
        @Published var errorMessage: String?
        @Published var sections: [MoviePresentationSection] = []
        let isLoading = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - Properties
    let moviesListUseCase: FetchMoviesListUseCaseType
    let favouritesUseCase: FetchFavouritesMoviesUseCaseType
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
                output.isLoading.send(true)
            })
            .flatMap { _ -> AnyPublisher<[MoviePresentationSection], Error> in
            
            // get movies list publisher
            let moviesListPublisher = moviesListUseCase.getMoviesList()
                .map {
                    // sorting the results
//                    $0.results
                    return self.sortMovies(movies: $0.results)
                }.eraseToAnyPublisher()
            
            // get favourites publisher
            let favouritesPublisher = favouritesUseCase
                .getFavourites()
                .catch ({ error in
                    return Just(ResponseModelWrapper(results: [])) // empty response as we ignore the error for the favourites
                })
                .setFailureType(to: Error.self)
                    .map { $0.results }
                .eraseToAnyPublisher()
            
            // zip publishers
            return Publishers.Zip(moviesListPublisher, favouritesPublisher)
                .receive(on: DispatchQueue.global())
                .map({ moviesList, favouritesList in
                    return self.generateSections(moviesList: moviesList, favourites: favouritesList)
                }).eraseToAnyPublisher()
        }
        .catch({ error in
            return Just([])
        }).sink(receiveValue: { items in
            output.sections = items
            output.isLoading.send(false)
        })
        .store(in: disposeBag)
        
        return output
    }
    
    private func generateSections(moviesList: [MovieModel], favourites: [FavouriteMovieModel]) -> [MoviePresentationSection] {
        
        var sections = [MoviePresentationSection]()
        
        var favouritesEntities = [MovieItemEntity]()
        var watchedEntities = [MovieItemEntity]()
        var toWatchEntities = [MovieItemEntity]()
        
        for movie in moviesList {
            let entity = MovieItemEntity(movie: movie)
            if favourites.contains(where: { $0.id == movie.id }) {
                favouritesEntities.append(entity)
                
                // if favourites contains this movie, means it should be displayed also in to watch and watched
                watchedEntities.append(entity)
                toWatchEntities.append(entity)
            } else {
                movie.isWatched ? watchedEntities.append(entity) : toWatchEntities.append(entity)
            }
        }
        
        // build sections
        sections.append(MoviePresentationSection(presentationType: .favorites, movies: favouritesEntities))
        sections.append(MoviePresentationSection(presentationType: .watched, movies: watchedEntities))
        sections.append(MoviePresentationSection(presentationType: .toWatch, movies: toWatchEntities))
        
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



