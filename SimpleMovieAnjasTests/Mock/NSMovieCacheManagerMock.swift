//
//  NSMovieCacheManagerMock.swift
//  SimpleMovieAnjasTests
//
//  Created by Anjas Dwi on 17/03/24.
//

import XCTest
@testable import SimpleMovieAnjas

final class NSMovieCacheManagerMock: NSMovieCacheManagerInterface {
    // Helper test
    private var cacheData: CacheMovieModel?

    func add(data: CacheMovieModel, name: String) {
        cacheData = data
    }

    func remove(name: String) { }

    func get(name: String) -> CacheMovieModel? {
        return cacheData
    }
}
