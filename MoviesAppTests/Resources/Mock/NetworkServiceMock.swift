//
//  NetworkServiceMock.swift
//  MoviesAppTests
//
//  Created by Madrit Kacabumi on 08.06.23.
//

@testable import MoviesApp
import Combine

class NetworkServiceMock: NetworkServiceType {
    
    let requestCounter = TestCounter()
    let requestImageCounter = TestCounter()
    
    func request<T>(resource: MoviesApp.APIResource, for type: T.Type) -> AnyPublisher<T, Error> where T : Decodable {
        requestCounter.increment()
        return PassthroughSubject<T, Error>().eraseToAnyPublisher()
    }
    
    func requestImage(resource: MoviesApp.APIResource) -> AnyPublisher<MoviesApp.Image, Error> {
        requestImageCounter.increment()
        return Just(Image())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
