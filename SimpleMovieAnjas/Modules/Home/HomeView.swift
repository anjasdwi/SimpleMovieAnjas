//
//  HomeView.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 13/03/24.
//

import UIKit

final class HomeView: UIView {

    let stateView = StateView().with {
        $0.isHidden = true
    }

    let searchBarView = SearchBarView()

    lazy var refreshControl = UIRefreshControl().with {
        $0.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        $0.tintColor(.blue.withAlphaComponent(0.5))
    }

    lazy var movieListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout().with {
            $0.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
            $0.minimumInteritemSpacing = 24
            $0.minimumLineSpacing = 24
        }

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout).with {
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = .white
            $0.alwaysBounceVertical = true
            $0.registerClass(with: [MovieCardCVC.self, LoadingCVC.self])
            $0.refreshControl = refreshControl
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
        searchBarView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }

        movieListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBarView.snp.bottom).offset(16)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }

        stateView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalTo(movieListCollectionView)
        }
    }

    private func setupViews() {
        addSubviews {
            searchBarView
            movieListCollectionView
        }

        movieListCollectionView.addSubviews { stateView }
    }
}
