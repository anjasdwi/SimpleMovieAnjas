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
}

protocol HomeViewModelOutput {
    var updateViewsSignal: Signal<Void> { get }
    var dataDummies: Driver<[HomeViewListSectionModel]> { get }
}

protocol HomeViewModelInterface: HomeViewModelInput, HomeViewModelOutput {}

final class HomeViewModel: HomeViewModelInterface {

    // MARK: Dispose bag
    private let disposeBag = DisposeBag()

    // MARK: View event methods
    let viewDidLoad = PublishRelay<Void>()

    // MARK: Observables for handle the data and section
    var dataDummies: Driver<[HomeViewListSectionModel]> {
        Observable
            .just(generateSectionModel())
            .asDriver(onErrorJustReturn: [])
    }

    // MARK: Update views observables
    private let updateViews = PublishRelay<Void>()
    var updateViewsSignal: Signal<Void> {
        updateViews.asSignal()
    }

    init() {
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
    }

}

// MARK: - Network
extension HomeViewModel {

    // FIXME: For dummies data
    func generateSectionModel() -> [HomeViewListSectionModel] {
        let item = MovieCardCVCViewModel(
            title: "Captain America: The First Avenger",
            year: "2011",
            type: "Movie",
            posterUrl: "https://m.media-amazon.com/images/M/MV5BNzAxMjg0NjYtNjNlOS00NTdlLThkMGEtMjAwYjk3NmNkOGFhXkEyXkFqcGdeQXVyNTgzMDMzMTg@._V1_SX300.jpg")

        let items: [MovieCardCVCViewModel] = Array(repeating: item, count: 10)

        return [HomeViewListSectionModel(items: items)]
    }

}
