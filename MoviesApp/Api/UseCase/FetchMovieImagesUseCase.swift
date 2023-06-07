//
//  FetchMovieImagesUseCase.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 07.06.23.
//

import Foundation
import Combine

protocol FetchMovieImagesUseCaseType {
    func fetchMovieImage(for imageName: String) -> AnyPublisher<Image, Error>
}

struct FetchMovieImagesUseCase: FetchMovieImagesUseCaseType {
    
    let network: NetworkServiceType
    
    func fetchMovieImage(for imageName: String) -> AnyPublisher<Image, Error> {
        let resource = TMDBImageResource(imageName: imageName)
        return network.requestImage(resource: resource)
    }
}
