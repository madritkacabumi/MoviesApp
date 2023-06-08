//
//  FetchMovieImageUseCase.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 07.06.23.
//

import Foundation
import Combine

protocol FetchMovieImageUseCaseType {
    func fetchMovieImage(for imageName: String) -> AnyPublisher<Image, Error>
}

struct FetchMovieImageUseCase: FetchMovieImageUseCaseType {
    
    let network: NetworkServiceType
    
    func fetchMovieImage(for imageName: String) -> AnyPublisher<Image, Error> {
        let resource = TMDBImageResource(imageName: imageName)
        return network.requestImage(resource: resource)
    }
    
}
