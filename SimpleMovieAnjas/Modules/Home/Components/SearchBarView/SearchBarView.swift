//
//  SearchBarView.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 14/03/24.
//

import UIKit

final class SearchBarView: UIView {

    let searchTextField = MovieTextField().with {
        let search = UIImage(named: IMAGE.icSearch)
        let leftIconFrame = CGRect(origin: .zero, size: CGSizeMake(36, 36))
        let leftIcon = UIImageView(frame: leftIconFrame).with { img in
            img.image = search
            img.layer.cornerRadius = 4
            img.contentMode = .scaleAspectFit
            img.tintColor = .gray.withAlphaComponent(0.7)
            img.snp.makeConstraints { make in
                make.width.equalTo(52)
            }
        }

        $0.leftView = leftIcon
        $0.leftViewMode = .always
        $0.placeholder = WORDING.searchMovie
    }

    let cancelLabel = UILabel()
        .numberOfLines(1)
        .textColor(.gray)
        .font(.systemFont(ofSize: 14))
        .text(WORDING.cancel).with {
            $0.isHidden = true
        }

    private lazy var mainSV = UIStackView()
        .axis(.horizontal)
        .distribution(.fill)
        .spacing(12)
        .addArrangedSubviews {
            searchTextField
            cancelLabel
        }

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
            make.height.equalTo(48)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview()
        }
    }

    private func setupViews() {
        addSubviews { mainSV }
    }
}

