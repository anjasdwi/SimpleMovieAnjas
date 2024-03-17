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
import RxGesture

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

        viewModel
            .showState
            .emit { [weak self] params in
                self?.mainView.stateView.with {
                    $0.isHidden = false
                    $0.descriptionLabel.text = params.description
                    $0.illustrationView.image(UIImage(named: params.illustration))
                    $0.button.setTitle(params.buttonTitle, for: .normal)
                }
            }.disposed(by: disposeBag)

        viewModel
            .resetSearchAndFocus
            .emit { [weak self] _ in
                self?.mainView.searchBarView.with {
                    $0.searchTextField.text = ""
                    $0.searchTextField.becomeFirstResponder()
                }
            }.disposed(by: disposeBag)

        mainView.movieListCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        typealias DataSource = RxCollectionViewSectionedReloadDataSource
        let dataSource = DataSource<HomeViewListSectionModel>(
              configureCell: { dataSource, tableView, indexPath, _ in
                  switch dataSource[indexPath] {
                  case .list(let viewModel):
                      let cell = tableView.dequeueReusableCell(
                        withReuseIdentifier: MovieCardCVC.reuseIdentifier,
                        for: indexPath) as! MovieCardCVC
                      cell.viewModel = viewModel
                      return cell
                  case .skeleton:
                      let cell = tableView.dequeueReusableCell(
                        withReuseIdentifier: MovieCardCVC.reuseIdentifier,
                        for: indexPath) as! MovieCardCVC
                      cell.showSkeleton()
                      return cell
                  case .paginationLoading:
                      let cell = tableView.dequeueReusableCell(
                        withReuseIdentifier: LoadingCVC.reuseIdentifier,
                        for: indexPath) as! LoadingCVC
                      cell.startAnimating()
                      return cell
                  }
            })

        viewModel
            .homeViewListSection
            .do(onNext: { [weak self] _ in
                self?.mainView.stateView.isHidden = true
            })
            .drive(mainView.movieListCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    /// Setup binding views
    private func bindViews() {

        mainView.searchBarView.searchTextField
            .rx.controlEvent(.editingDidBegin)
            .do(afterNext: { [weak self] in
                self?.hideNavigationBar()
            })
            .map { _ in false }
            .bind(to: mainView.searchBarView.cancelLabel.rx.isHidden)
            .disposed(by: disposeBag)

        mainView.searchBarView.cancelLabel
            .rx.tapGesture()
            .when(.recognized)
            .do(afterNext: { [weak self] _ in
                self?.mainView.movieListCollectionView.setContentOffset(.zero, animated: false)
                self?.showNavigationBar()
                self?.mainView.searchBarView.with {
                    $0.searchTextField.text = ""
                    $0.cancelLabel.isHidden = true
                }
            })
            .map { _ in "" }
            .bind(to: viewModel.searchKeyword)
            .disposed(by: disposeBag)

        // Subscribe content offset changes event of collection view
        mainView.movieListCollectionView
            .rx.contentOffset
            .bind { [weak self] val in
                guard let self else { return }
                let cv = self.mainView.movieListCollectionView
                self.view.endEditing(true)
                if val.y >= (cv.contentSize.height - cv.frame.size.height) {
                    self.viewModel.goToNextPage.accept(())
                }
            }.disposed(by: disposeBag)

        mainView.searchBarView.searchTextField
            .rx.controlEvent(.editingChanged)
            .debounce(.milliseconds(700), scheduler: MainScheduler.instance)
            .withLatestFrom(mainView.searchBarView.searchTextField.rx.text.orEmpty)
            .bind(to: self.viewModel.searchKeyword)
            .disposed(by: disposeBag)

        mainView.stateView.button
            .rx.tapGesture()
            .map { _ in Void() }
            .bind(to: viewModel.didTappedStateButton)
            .disposed(by: disposeBag)

    }
}

// MARK: - Helper views
extension HomeViewController: UICollectionViewDelegateFlowLayout {

    private func setupViews() {
        title = WORDING.home
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = view.frame.size.width
        switch indexPath.section {
        case 0:
            return CGSize(width: (width * 0.5) - 28, height: 280)
        default:
            return CGSize(width: width, height: 24)
        }

    }

}
