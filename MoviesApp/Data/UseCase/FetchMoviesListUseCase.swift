//
//  FetchMoviesListUseCase.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 5.6.23.
//

import Foundation
import Combine

protocol FetchMoviesListUseCaseType {
    func getMoviesList() -> AnyPublisher<ResponseModelWrapper<MovieModel>, Error>
}

struct FetchMoviesListUseCase: FetchMoviesListUseCaseType {
    
    let network: NetworkServiceType
    
    func getMoviesList() -> AnyPublisher<ResponseModelWrapper<MovieModel>, Error> {
        let resource = MoviesListResource()
        return network.request(resource: resource, for: ResponseModelWrapper<MovieModel>.self)
    }
}
