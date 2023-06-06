//
//  APIRequest.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 5.6.23.
//

import Alamofire
import Foundation

struct APIRequest: URLRequestConvertible {
    
    let resource: APIResource
    
    func asURLRequest() throws -> URLRequest {
        
        let requestURL = try resource.requestURLString.asURL()
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = resource.method.rawValue
        
        resource.headers?.forEach { (field, value) in
            urlRequest.setValue(value, forHTTPHeaderField: field)
        }
        
        if let parameters = resource.parameters {
            if resource.method == .post {
                urlRequest = try JSONEncoding().encode(urlRequest, with: parameters)
            } else {
                urlRequest = try URLEncoding().encode(urlRequest, with: parameters)
            }
        }
        
        return urlRequest
    }
}
