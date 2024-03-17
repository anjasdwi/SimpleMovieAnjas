//
//  NSObject+Withable.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 14/03/24.
//

import UIKit

/// Simple protocol to make constructing and modifying objects
/// with multiple properties simpler and more readable
protocol Withable {
    associatedtype Typ

    @discardableResult func with(_ closure: (_ instance: Typ) -> Void) -> Typ
}

extension Withable {

    @discardableResult
    func with(_ closure: (_ instance: Self) -> Void) -> Self {
        closure(self)
        return self
    }

}

extension NSObject: Withable { }
