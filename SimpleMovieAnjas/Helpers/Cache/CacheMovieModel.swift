//
//  CacheMovieModel.swift
//  SimpleMovieAnjas
//
//  Created by Engineer on 15/03/24.
//

import Foundation

class CacheMovieModel: NSDiscardableContent {
    let datas: [MovieDetailModel]

    init(datas: [MovieDetailModel]) {
        self.datas = datas
    }

    /// True if the content is still available and have been successfully accessed.
    func beginContentAccess() -> Bool {
        return true
    }

    /// Called when the content is no longer being accessed.
    func endContentAccess() { }

    /// Called when the content is no longer being accessed.
    func discardContentIfPossible() { }

    /// True if the content has been discarded.
    func isContentDiscarded() -> Bool {
        return false
    }
    
}
