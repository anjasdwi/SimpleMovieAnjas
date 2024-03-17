//
//  ReuseIdentifying.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 14/03/24.
//

/// Protocol for assigning a string identifier any object
protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {

    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }

}
