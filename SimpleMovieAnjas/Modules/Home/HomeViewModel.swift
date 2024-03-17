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
    var goToNextPage: PublishRelay<Void> { get }
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
    let didTappedStateButton = PublishRelay<Void>()

    // MARK: Pagination manager
    let searchKeyword = BehaviorRelay<String>(value: "")
    var page = 1
    var pageLoading = true
    let goToNextPage = PublishRelay<Void>()

    // MARK: Observables for handle the data and section
    var movieDetailModels: [MovieDetailModel] = []
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
                // reset pagination manager
                self?.pageLoading = false
                self?.page = 1
                self?.fetchMovie(term: term)
            }.disposed(by: disposeBag)

        goToNextPage
            .skip(1)
            .withLatestFrom(searchKeyword)
            .bind { [weak self] term in
                guard let self else { return }
                self.fetchMovieFromPagination(term: termsFormatted(from: term), page: self.page)
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

            cacheChecking { cacheDatas in
                self.movieDetailModels = cacheDatas
                self._homeViewListSection.accept(self.getListSection(from: self.movieDetailModels))
            } onNotFound: {
                self._showState.accept(.noConnection)
            }

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

    /// Method for fetch data
    func fetchMovie(term: String) {
        // Checking by page loading
        // if from pagination and page loading is true, then return
        // otherwise set page loading to true
        if pageLoading { return }
        else { pageLoading = true }

        // Checking cache
        // if there is any cache, then fetch cache
        // otherwise fetch from remote
        cacheChecking { cacheDatas in
            // update list section
            updateListSection(isFromPagination: false, datas: cacheDatas)
            // Helper used by pagination
            self.pageLoading = false
            self.page += 1
        } onNotFound: {
            fetchData()
        }

        func fetchData() {
            connectivity.stop()

            // Add loading skeleton into section
            _homeViewListSection.accept(getSkeletonSection())

            let req = MovieRequestParams(term: term, page: 1)
            movieNetworkService.getMovieList(requestParams: req) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let movieListModel):
                    if let datas = movieListModel.search {
                        // Add data to cache
                        cacheManager.add(data: CacheMovieModel(datas: datas), name: "\(term)\(self.page)")
                        // update list section
                        self.updateListSection(isFromPagination: false, datas: datas)
                        // Helper used by pagination
                        self.pageLoading = false
                        self.page += 1
                    } else {
                        self._homeViewListSection.accept(self.getListSection(from: []))
                        self._showState.accept(.empty)
                    }
                case .failure(let error):
                    self._homeViewListSection.accept(self.getListSection(from: []))
                    switch error {
                    case .noInternetConnection:
                        self._showState.accept(.noConnection)
                        self.connectivity.start()
                    default:
                        self._showState.accept(.error)
                    }
                }

            }
        }
    }

    /// Method for fetch data using pagination
    func fetchMovieFromPagination(
        term: String,
        page: Int = 1
    ) {
        // Checking by page loading
        // if page loading is true, then return
        // otherwise set page loading to true
        if pageLoading { return }
        else { pageLoading = true }

        // Checking cache
        // if there is any cache, then fetch cache
        // otherwise fetch from remote
        cacheChecking { cacheDatas in
            // update list section
            updateListSection(isFromPagination: true, datas: cacheDatas)
            // Helper used by pagination
            self.pageLoading = false
            self.page += 1
        } onNotFound: {
            fetchData()
        }

        func fetchData() {
            connectivity.stop()

            // Add pagination loading into section
            _homeViewListSection.accept(getSectionWithPaginationLoading())

            let req = MovieRequestParams(term: term, page: page)
            movieNetworkService.getMovieList(requestParams: req) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let movieListModel):
                    if let datas = movieListModel.search {
                        // Add data to cache
                        self.cacheManager.add(data: CacheMovieModel(datas: datas), name: "\(term)\(page)")
                        // update list section
                        self.updateListSection(isFromPagination: true, datas: datas)
                        // Helper used by pagination
                        self.pageLoading = false
                        self.page += 1
                    } else {
                        self._homeViewListSection.accept(self.getSectionWithoutPaginationLoading())
                    }
                default:
                    self._homeViewListSection.accept(self.getSectionWithoutPaginationLoading())
                }

            }
        }
    }

}
