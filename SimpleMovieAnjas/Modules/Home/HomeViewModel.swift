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
    let goToNextPage = PublishRelay<Void>()
    var page = 1
    var pageLoading = true

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
    let _showState = PublishRelay<StateViewCases>()
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
    let movieNetworkService: MovieRepositoryInterface
    let cacheManager: NSMovieCacheManagerInterface
    var connectivity: ConnectivityInterface

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
