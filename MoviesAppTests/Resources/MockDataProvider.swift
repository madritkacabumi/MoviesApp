//
//  MockDataProvider.swift
//  MoviesAppTests
//
//  Created by Madrit Kacabumi on 07.06.23.
//

import Foundation
@testable import MoviesApp

fileprivate class FakeClassForBundle: NSObject {  }

struct MockProvider {
    
    static var moviesListResponse: ResponseModelWrapper<MovieModel>? {
        Self.readMockJsonFile(jsonFileName: "MockMoviesList")
    }
    
    static var favouritesListResponse: ResponseModelWrapper<FavouriteMovieModel>? {
        Self.readMockJsonFile(jsonFileName: "MockFavourites")
    }
}

extension MockProvider {
    
    private static func readMockJsonFile<E: Codable>(jsonFileName: String) -> E? {
        if let url = Bundle(for: FakeClassForBundle.self).url(forResource: jsonFileName, withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode(E.self, from: data) {
            return decoded
        }
        
        return nil
    }
}
