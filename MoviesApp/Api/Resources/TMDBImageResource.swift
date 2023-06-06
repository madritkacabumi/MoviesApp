//
//  TMDBImageResource.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 5.6.23.
//

import Alamofire

struct TMDBImageResource: APIResource {
    
    let method: HTTPMethod = .get
    
    let parameters: Parameters? = nil
    
    let headers: [String : String]? = [:]
    
    let requestURLString: String
    
    init(imageName: String) {
        self.requestURLString = APIConfig.imagesEndpoint + "/\(imageName)"
    }
}
