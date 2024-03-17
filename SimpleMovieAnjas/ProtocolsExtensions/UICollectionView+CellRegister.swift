//
//  UICollectionView+CellRegister.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 14/03/24.
//

import UIKit

extension UICollectionView {

    /// Registering `cell` using `class` that conforms `ReuseIdentifying` protocol in current instance collection view.
    func registerClass(with cellClasses: [UICollectionViewCell.Type]) {
        cellClasses.forEach { cell in
            if let cellType = cell.self as? ReuseIdentifying.Type {
                self.register(
                    cell,
                    forCellWithReuseIdentifier: cellType.reuseIdentifier)
            }
        }
    }

}
