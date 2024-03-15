//
//  Dictionary+Modified.swift
//  SimpleMovieAnjas
//
//  Created by Engineer on 15/03/24.
//

import Foundation

extension Dictionary {

    mutating func merge(dict: [Key: Value]) {
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }

}
