//
//  FavouritesMoviesResource.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 5.6.23.
//

import Alamofire

struct FavouritesMoviesResource: APIResource {
    
    let httpMethod: HTTPMethod = .get
    
    let parameters: Parameters? = nil
    
    let headers: [String : String]? = [:]
    
    let requestURLString: String = {
        return APIConfig.baseApi + "/favorites"
    }()
    
}
