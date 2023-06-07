//
//  FetchMoviesListUseCaseMock.swift
//  MoviesAppTests
//
//  Created by Madrit Kacabumi on 07.06.23.
//

@testable import MoviesApp
import Combine

struct FetchMoviesListUseCaseMock: FetchMoviesListUseCaseType {
    
    var isFailure: Bool
    
    var counter = TestCounter()
    
    func getMoviesList() -> AnyPublisher<ResponseModelWrapper<MovieModel>, Error> {
        
        counter.increment()
        
        if isFailure {
            return Fail<ResponseModelWrapper<MovieModel>, Error>(error: CustomError(message: "Some failure occurred!"))
                .eraseToAnyPublisher()
        } else {
            return Just(MockProvider.moviesListResponse!)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
