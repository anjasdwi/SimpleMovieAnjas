//
//  HomeViewModel.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 14/03/24.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

protocol HomeViewModelInput {
    var viewDidLoad: PublishRelay<Void> { get }
    var searchKeyword: BehaviorRelay<String> { get }
    var didTappedStateButton: PublishRelay<Void> { get }
}

protocol HomeViewModelOutput {
    var updateViewsSignal: Signal<Void> { get }
    var homeViewListSection: Driver<[HomeViewListSectionModel]> { get }
    var showState: Signal<StateViewCases.StateViewParams> { get }
    var resetSearchAndFocus: Signal<Void> { get }
}

protocol HomeViewModelInterface: HomeViewModelInput, HomeViewModelOutput {}

final class HomeViewModel: HomeViewModelInterface {

    // MARK: Dispose bag
    private let disposeBag = DisposeBag()

    // MARK: View event methods
    let viewDidLoad = PublishRelay<Void>()
    let searchKeyword = BehaviorRelay<String>(value: "")
    let didTappedStateButton = PublishRelay<Void>()

    // MARK: Observables for handle the data and section
    let _homeViewListSection = BehaviorRelay<[HomeViewListSectionModel]>(value: [])
    var homeViewListSection: Driver<[HomeViewListSectionModel]> {
        _homeViewListSection.asDriver()
    }

    // MARK: Update views observables
    private let updateViews = PublishRelay<Void>()
    var updateViewsSignal: Signal<Void> {
        updateViews.asSignal()
    }

    // MARK: State views observables
    private let _showState = PublishRelay<StateViewCases>()
    var showState: Signal<StateViewCases.StateViewParams> {
        _showState
            .map { $0.params }
            .asSignal(onErrorJustReturn: (description: "", illustration: "", buttonTitle: ""))
    }

    // MARK: Reset and focus input search observables
    private let _resetSearchAndFocus = PublishRelay<Void>()
    var resetSearchAndFocus: Signal<Void> {
        _resetSearchAndFocus.asSignal()
    }

    // MARK: - Managers
    private let movieNetworkService: MovieRepositoryInterface
    private var connectivity: ConnectivityInterface
    let cacheManager: NSMovieCacheManagerInterface

    init(
        movieNetworkService: MovieRepositoryInterface = MovieRepository(),
        cacheManager: NSMovieCacheManagerInterface = NSMovieCacheManager.shared,
        connectivity: ConnectivityInterface = Connectivity()
    ) {
        self.movieNetworkService = movieNetworkService
        self.cacheManager = cacheManager
        self.connectivity = connectivity
        self.bindInput()
    }
}

// MARK: - INPUT. View event methods
extension HomeViewModel {

    /// Setup binding input
    private func bindInput() {
        viewDidLoad
            .bind(to: updateViews)
            .disposed(by: disposeBag)

        searchKeyword
            .map(termsFormatted)
            .bind { [weak self] term in
                self?.fetchMovieList(term: term)
            }.disposed(by: disposeBag)

        didTappedStateButton
            .withLatestFrom(_showState)
            .bind { [weak self] state in
                switch state {
                case .empty:
                    self?._resetSearchAndFocus.accept(())
                    self?.searchKeyword.accept("")
                case .error:
                    let lastTerm = self?.searchKeyword.value ?? ""
                    self?.searchKeyword.accept(lastTerm)
                default: break
                }
            }.disposed(by: disposeBag)

        connectivity.noConnectAction = { [weak self] in
            guard let self else { return }
            cacheChecking(onNotFound: { self._showState.accept(.noConnection) })
        }

        connectivity.connectAction = { [weak self] in
            guard let self else { return }
            let lastTerm = self.searchKeyword.value
            self.searchKeyword.accept(lastTerm)
        }
    }

}

// MARK: - Network
extension HomeViewModel {

    /// Fetch data from movie list
    private func fetchMovieList(term: String, page: Int = 1) {

        cacheChecking(onNotFound: { fetchFromRemote() })

        /// Method for fetch data from remote
        func fetchFromRemote() {
            connectivity.stop()
            _homeViewListSection.accept(getSkeletonSection())

            let req = MovieRequestParams(term: term, page: page)
            movieNetworkService.getMovieList(requestParams: req) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let movieListModel):
                    if let datas = movieListModel.search {
                        cacheManager.add(data: CacheMovieModel(datas: datas), name: "\(term)\(page)")
                        self._homeViewListSection.accept(self.getListSection(from: datas))
                    } else {
                        self._homeViewListSection.accept(self.getListSection(from: []))
                        self._showState.accept(.empty)
                    }
                case .failure(let error):
                    switch error {
                    case .noInternetConnection:
                        self._homeViewListSection.accept(self.getListSection(from: []))
                        self._showState.accept(.noConnection)
                        self.connectivity.start()
                    default:
                        self._homeViewListSection.accept(self.getListSection(from: []))
                        self._showState.accept(.error)
                    }
                }
            }
        }
    }

}
