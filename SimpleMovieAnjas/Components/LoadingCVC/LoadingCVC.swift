//
//  LoadingCVC.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 17/03/24.
//

import UIKit

final class LoadingCVC: UICollectionViewCell, ReuseIdentifying {

    private let spinner = UIActivityIndicatorView().with {
        $0.color = .blue.withAlphaComponent(0.5)
        $0.startAnimating()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        spinner.stopAnimating()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setuplayouts()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setuplayouts()
    }

    private func setuplayouts() {
        spinner.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }

    private func setupViews() {
        contentView.addSubview(spinner)
    }

    func startAnimating() {
        spinner.startAnimating()
    }

}
