//
//  ResponseModelWrapper.swift
//  MoviesApp
//
//  Created by Madrit Kacabumi on 5.6.23.
//

import Foundation

struct ResponseModelWrapper<T: Codable>: Codable {
    let results: [T]
}
