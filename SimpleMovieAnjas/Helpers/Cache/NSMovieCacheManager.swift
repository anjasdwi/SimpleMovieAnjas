//
//  NSCacheManager.swift
//  SimpleMovieAnjas
//
//  Created by Engineer on 15/03/24.
//

import Foundation

protocol NSMovieCacheManagerInterface {
    func add(data: CacheMovieModel, name: String)
    func get(name: String) -> CacheMovieModel?
    func remove(name: String)
}

final class NSMovieCacheManager: NSMovieCacheManagerInterface {

    static let shared = NSMovieCacheManager()

    private init() { }

    private var dataCache: NSCache<NSString, CacheMovieModel> = {
        let cache = NSCache<NSString, CacheMovieModel>()
        return cache
    }()

    func add(data: CacheMovieModel, name: String) {
        dataCache.setObject(data, forKey: name as NSString)
    }

    func get(name: String) -> CacheMovieModel? {
        guard let data = dataCache.object(forKey: name as NSString) else {
            return nil
        }
        return data
    }

    func remove(name: String) {
        dataCache.removeObject(forKey: name as NSString)
    }
}
