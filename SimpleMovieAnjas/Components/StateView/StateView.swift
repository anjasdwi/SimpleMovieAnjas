//
//  StateView.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 15/03/24.
//

import UIKit

final class StateView: UIView {

    let illustrationView = UIImageView()
        .contentMode(.scaleAspectFit)
        .with {
            $0.snp.makeConstraints { make in
                make.size.equalTo(200)
            }
        }

    let descriptionLabel = UILabel()
        .numberOfLines(0)
        .textColor(.gray)
        .textAlignment(.center)
        .font(.systemFont(ofSize: 14))
        .with {
            $0.snp.makeConstraints { make in
                make.width.equalTo(224)
            }
        }

    let button = ButtonMovie().with {
        $0.snp.makeConstraints { make in
            make.width.equalTo(200)
        }
    }

    private lazy var mainSV = UIStackView {
        illustrationView
        descriptionLabel
        button
    }
        .axis(.vertical)
        .distribution(.fill)
        .alignment(.center)
        .spacing(24)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor(.white)
        setupViews()
        layoutViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        layoutViews()
    }

    private func layoutViews() {
        mainSV.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview().inset(24)
        }
    }

    private func setupViews() {
        addSubviews { mainSV }
    }
}


