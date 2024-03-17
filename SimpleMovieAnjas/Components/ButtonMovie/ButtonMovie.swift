//
//  Button.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 15/03/24.
//

import UIKit

final class ButtonMovie: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        layoutViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        layoutViews()
    }

    private func layoutViews() {
        snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }

    private func setupViews() {
        backgroundColor(.blue)
        cornerRadius(16)
    }
    
}
