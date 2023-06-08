//
//  FetchFavouritesMoviesUseCase.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 5.6.23.
//

import Foundation
import Combine

protocol FetchFavouritesMoviesUseCaseType {
    func getFavourites() -> AnyPublisher<ResponseModelWrapper<FavouriteMovieModel>, Error>
}

struct FetchFavouritesMoviesUseCase: FetchFavouritesMoviesUseCaseType {

    let network: NetworkServiceType
    
    func getFavourites() -> AnyPublisher<ResponseModelWrapper<FavouriteMovieModel>, Error> {
        let resource = FavouritesMoviesResource()
        return network.request(resource: resource, for: ResponseModelWrapper<FavouriteMovieModel>.self)
    }
    
}
