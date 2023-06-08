//
//  FetchMovieImageUseCaseMock.swift
//  MoviesAppTests
//
//  Created by Madrit Kacabumi on 07.06.23.
//

@testable import MoviesApp
import Combine

struct FetchMovieImageUseCaseMock: FetchMovieImageUseCaseType {
    
    var counter = TestCounter()
    
    func fetchMovieImage(for imageName: String) -> AnyPublisher<MoviesApp.Image, Error> {
        
        counter.increment()
        
        return Just(Styles.Image.appIcon ?? Image())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
}
