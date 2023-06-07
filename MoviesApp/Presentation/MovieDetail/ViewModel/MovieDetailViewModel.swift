//
//  MovieDetailViewModel.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 07.06.23.
//

import Foundation
import Combine

struct MovieAttributes {
    let label: String
    let value: String
}

struct MovieDetailViewModel {
    
    // MARK: - I/O
    struct Input {
        let loadPageTrigger: Trigger<Void>
    }
    
    class Output {
        @Published var loaded: Bool = false
        var title: String = ""
        var loadImagePublisher: AnyPublisher<Image?, Never>?
        var attributes: [MovieAttributes] = []
    }
    
    // MARK: - Properties
    private let movie: MovieModel
    private let fetchImageUseCase: FetchMovieImagesUseCaseType
    
    // MARK: - Construct
    init(movie: MovieModel, fetchImageUseCase: FetchMovieImagesUseCaseType) {
        self.movie = movie
        self.fetchImageUseCase = fetchImageUseCase
    }
    
    /// Transforms the input of the view to the output needed for the view to bind to.
    /// - Parameters:
    ///   - input: input given by view
    ///   - disposeBag: Cancellable bag to store cancellables
    /// - Returns: the Output required for the view to bind
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let output = Output()
        
        input.loadPageTrigger.sink { _ in
            output.title = movie.title
            output.loadImagePublisher = fetchImageUseCase
                .fetchMovieImage(for: movie.posterPath)
                .map ({ image -> Image? in
                    return image
                })
                .catch({ error in
                    return Just(nil)
                }).eraseToAnyPublisher()
                
            output.attributes = self.loadAttributes(movie: movie)
            output.loaded = true
        }.store(in: disposeBag)
        return output
    }
    
    private func loadAttributes(movie: MovieModel) -> [MovieAttributes] {
        var attributes = [MovieAttributes]()
        attributes.append(MovieAttributes(label: "Description:", value: movie.overview))
        attributes.append(MovieAttributes(label: "Rating:", value: String(format: "%.2f ⭐", movie.rating)))
        attributes.append(MovieAttributes(label: "Date:", value: movie.releaseDate)) // Do we need to format the date?
        attributes.append(MovieAttributes(label: "Original language:", value: movie.originalLanguage))
        return attributes
    }
}
