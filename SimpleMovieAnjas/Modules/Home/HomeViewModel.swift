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
}

protocol HomeViewModelOutput {
    var updateViewsSignal: Signal<Void> { get }
    var homeViewListSection: Driver<[HomeViewListSectionModel]> { get }
}

protocol HomeViewModelInterface: HomeViewModelInput, HomeViewModelOutput {}

final class HomeViewModel: HomeViewModelInterface {

    // MARK: Dispose bag
    private let disposeBag = DisposeBag()

    // MARK: View event methods
    let viewDidLoad = PublishRelay<Void>()
    let searchKeyword = BehaviorRelay<String>(value: "")

    // MARK: Observables for handle the data and section
    private let _homeViewListSection = BehaviorRelay<[HomeViewListSectionModel]>(value: [])
    var homeViewListSection: Driver<[HomeViewListSectionModel]> {
        _homeViewListSection
            .asDriver()
    }

    // MARK: Update views observables
    private let updateViews = PublishRelay<Void>()
    var updateViewsSignal: Signal<Void> {
        updateViews.asSignal()
    }

    // MARK: - Managers
    private let movieNetworkService: MovieRepositoryInterface

    init(movieNetworkService: MovieRepositoryInterface = MovieRepository()) {
        self.movieNetworkService = movieNetworkService
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
            .map { $0.isEmpty ? "man" : $0 }
            .bind { [weak self] term in
                self?.fetchMovieList(term: term)
            }.disposed(by: disposeBag)
    }

}

// MARK: - Network
extension HomeViewModel {

    /// Fetch data from movie list API
    private func fetchMovieList(term: String) {

        let req = MovieRequestParams(term: term, page: 1)
        movieNetworkService.getMovieList(requestParams: req) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let movieListModel):
                _homeViewListSection.accept(generateSectionModel(from: movieListModel.search ?? []))
            case .failure(let error):
                print("Handle error here", error)
            }

        }

    }

    private func generateSectionModel(from model: [MovieDetailModel]) -> [HomeViewListSectionModel] {
        let items = model.map {
            MovieCardCVCViewModel(
                title: $0.title ?? "",
                year: $0.year ?? "",
                type: $0.type ?? "",
                posterUrl: $0.poster ?? ""
            )
        }

        return [HomeViewListSectionModel(items: items)]
    }

}
