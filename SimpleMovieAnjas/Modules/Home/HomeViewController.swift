//
//  ViewController.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 13/03/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class HomeViewController: BaseViewController {

    static func create(
        withViewModel viewModel: HomeViewModelInterface
    ) -> HomeViewController {
        let view = HomeViewController()
        view.viewModel = viewModel
        return view
    }

    let mainView = HomeView()

    var viewModel: HomeViewModelInterface!

    private let disposeBag = DisposeBag()

    override func loadView() {
        self.view = self.mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindViews()
        viewModel.viewDidLoad.accept(())
    }

}

// MARK: - Bindings
extension HomeViewController {
    
    /// Setup binding view model
    private func bindViewModel() {
        viewModel
            .updateViewsSignal
            .emit { [weak self] _ in
                self?.setupViews()
            }.disposed(by: disposeBag)

        mainView.movieListCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        typealias DataSource = RxCollectionViewSectionedReloadDataSource
        let dataSource = DataSource<HomeViewListSectionModel>(
              configureCell: { _, tableView, indexPath, viewModel in

                  let cell = tableView.dequeueReusableCell(
                    withReuseIdentifier: MovieCardCVC.reuseIdentifier,
                    for: indexPath) as! MovieCardCVC
                  cell.viewModel = viewModel

                  return cell

            })

        viewModel
            .dataDummies
            .drive(mainView.movieListCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

    }

    /// Setup binding views
    private func bindViews() { }
}

// MARK: - Helper views
extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = view.frame.size.width
        return CGSize(width: (width * 0.5) - 28, height: 280)
    }

    private func setupViews() {
        self.title = WORDING.home
    }
}
