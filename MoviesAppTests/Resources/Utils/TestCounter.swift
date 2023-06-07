//
//  TestCounter.swift
//  MoviesAppTests
//
//  Created by Madrit Kacabumi on 07.06.23.
//

import Foundation

class TestCounter {
    
    var count: Int = .zero
    
    func increment() {
        count += 1
    }
    
    func reset() {
        count = .zero
    }
}
