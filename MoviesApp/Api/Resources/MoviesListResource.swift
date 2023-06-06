//
//  MoviesListResource.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 5.6.23.
//

import Alamofire

struct MoviesListResource: APIResource {
    
    let method: HTTPMethod = .get
    
    let parameters: Parameters? = nil
    
    let headers: [String : String]? = [:]
    
    let requestURLString: String = {
        return APIConfig.baseApi + "/list"
    }()
    
}
