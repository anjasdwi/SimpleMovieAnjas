//
//  MockHomeViewModelTest.swift
//  SimpleMovieAnjasTests
//
//  Created by Engineer on 17/03/24.
//

import XCTest
import RxSwift
import RxCocoa
@testable import SimpleMovieAnjas

class HomeViewModelMock: HomeViewModelInterface {
    var viewDidLoad = PublishRelay<Void>()
    var searchKeyword = BehaviorRelay<String>(value: "")
    var didTappedStateButton = PublishRelay<Void>()
    var goToNextPage = PublishRelay<Void>()

    let _updateViewsSignal = PublishRelay<Void>()
    let _resetSearchAndFocus = PublishRelay<Void>()
    let _homeViewListSection = BehaviorRelay<[HomeViewListSectionModel]>(value: [])
    let _showState = PublishRelay<StateViewCases.StateViewParams>()

    var updateViewsSignal: Signal<Void> {
        viewDidLoad.asSignal()
    }

    var homeViewListSection: Driver<[HomeViewListSectionModel]>{
        _homeViewListSection.asDriver()
    }

    var showState: Signal<StateViewCases.StateViewParams> {
        _showState.asSignal()
    }

    var resetSearchAndFocus: Signal<Void> {
        didTappedStateButton
            .asSignal()
    }
    
    init() {
        setupBinding()
    }

    private func setupBinding() { }

}
