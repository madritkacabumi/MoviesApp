//
//  APIResource.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 5.6.23.
//

import Alamofire

protocol APIResource {
    var httpMethod: HTTPMethod { get }
    var requestURLString: String { get }
    var parameters: Parameters? { get }
    var headers: [String: String]? { get }
    
}
