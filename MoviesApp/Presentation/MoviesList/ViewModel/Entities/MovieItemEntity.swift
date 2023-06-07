//
//  MovieItemEntity.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 07.06.23.
//

import Foundation
import Combine

struct MovieItemEntity {
    
    private var fetchImageUseCase: FetchMovieImageUseCaseType
    var _movieModel: MovieModel
    var isSelected: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    var title: String { _movieModel.title }
    
    var imagePublisher: AnyPublisher<Image?, Never> {
        
        return fetchImageUseCase
            .fetchMovieImage(for: _movieModel.posterPath)
            .map({ image -> Image? in
                return image
            })
            .catch { error in
                return Just(nil)
            }.eraseToAnyPublisher()
    }
    
    init(movie: MovieModel, useCase: FetchMovieImageUseCaseType) {
        self.fetchImageUseCase = useCase
        self._movieModel = movie
    }
}

// MARK: - Equatable
extension MovieItemEntity: Equatable {
    static func == (lhs: MovieItemEntity, rhs: MovieItemEntity) -> Bool {
        return lhs._movieModel.id == rhs._movieModel.id
    }
}
