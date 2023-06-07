//
//  FetchFavouritesMoviesUseCaseMock.swift
//  MoviesAppTests
//
//  Created by Madrit Kacabumi on 07.06.23.
//

@testable import MoviesApp
import Combine

struct FetchFavouritesMoviesUseCaseMock: FetchFavouritesMoviesUseCaseType {
    
    var counter = TestCounter()
    
    func getFavourites() -> AnyPublisher<ResponseModelWrapper<FavouriteMovieModel>, Error> {
        counter.increment()
        
        return Just(MockProvider.favouritesListResponse!)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
