//
//  MockResource.swift
//  MoviesAppTests
//
//  Created by Madrit Kacabumi on 08.06.23.
//

@testable import MoviesApp
import Alamofire

class MockResource: APIResource {
    
    let httpMethod: Alamofire.HTTPMethod
    var requestURLString: String = "https://example.com/someApi"
    var parameters: Alamofire.Parameters? = ["ParamKey": "ParamValue"]
    var headers: [String: String]? = ["Header_Key": "Header Value"]
    
    init(httpMethod: Alamofire.HTTPMethod) {
        self.httpMethod = httpMethod
    }
    
}
