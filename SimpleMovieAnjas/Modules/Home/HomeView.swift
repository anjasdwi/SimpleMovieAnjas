//
//  HomeView.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 13/03/24.
//

import UIKit

final class HomeView: UIView {

    lazy var movieListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout().with {
            $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            $0.minimumInteritemSpacing = 24
            $0.minimumLineSpacing = 24
        }

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout).with {
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .white
            $0.registerClass(with: [MovieCardCVC.self])
        }

        return cv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
        layoutViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        layoutViews()
    }

    private func layoutViews() {
        movieListCollectionView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    private func setupViews() {
        addSubviews { movieListCollectionView }
    }
}
