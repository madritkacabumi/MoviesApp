//
//  NetworkTests.swift
//  MoviesAppTests
//
//  Created by Madrit Kacabumi on 08.06.23.
//

@testable import MoviesApp
import XCTest
import Combine

class NetworkTests: XCTestCase {
    
    func test_MoviesListResource() {
        let moviesListResource = MoviesListResource()
        XCTAssertFalse(moviesListResource.requestURLString.isEmpty)
    }
    
    func test_FavouritesResource() {
        let favouritesResource = FavouritesMoviesResource()
        XCTAssertFalse(favouritesResource.requestURLString.isEmpty)
    }
    
    func test_TMDBImageResource() {
        let imageResource = TMDBImageResource(imageName: "Dummy.png")
        XCTAssertFalse(imageResource.requestURLString.isEmpty)
    }
    
    func test_apiRequest() {
        let apiRequest = APIRequest(resource: MockResource(httpMethod: .get))
        XCTAssertNoThrow(try apiRequest.asURLRequest())
        
        let apiRequest2 = APIRequest(resource: MockResource(httpMethod: .post))
        XCTAssertNoThrow(try apiRequest2.asURLRequest())
    }
    
}
