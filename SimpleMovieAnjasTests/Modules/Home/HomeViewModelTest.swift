//
//  HomeViewModelTest.swift
//  SimpleMovieAnjasTests
//
//  Created by Anjas Dwi on 16/03/24.
//

import XCTest
import RxTest
import RxSwift
import RxBlocking
@testable import SimpleMovieAnjas

class HomeViewModelTests: XCTestCase {

    // MARK: Data members
    private var sut: HomeViewModelInterface!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var movieNetworkService: MovieRepositoryInterface!
    private var cacheManager: NSMovieCacheManagerInterface!

    // MARK: Overrides
    override func setUp() {
        super.setUp()
        self.scheduler = TestScheduler(initialClock: 0)
        self.movieNetworkService = MovieRepositoryMock()
        self.cacheManager = NSMovieCacheManagerMock()
        self.sut = HomeViewModel(
            movieNetworkService: movieNetworkService,
            cacheManager: cacheManager)
        self.disposeBag = DisposeBag()
    }

    override func tearDown() {
        self.sut = nil
        self.disposeBag = nil
        self.scheduler = nil
        self.movieNetworkService = nil
        super.tearDown()
    }
}

extension HomeViewModelTests {

    func test_didLoadEventShoulTriggerUpdateViews() {
        // create testable observers
        let eventObserver = scheduler.createObserver(Bool.self)

        // bind the result
        sut.updateViewsSignal
            .map { true }
            .emit(to: eventObserver)
            .disposed(by: disposeBag)

        // when did load triggered
        scheduler.createColdObservable([.next(1, ())])
            .bind(to: sut.viewDidLoad)
            .disposed(by: disposeBag)

        scheduler.start()

        XCTAssertEqual(eventObserver.events, [.next(1, true)])
    }

    func test_fetchWithEmptyResponse() {
        // create testable observers
        let messageObserver = scheduler.createObserver(String.self)

        // bind the result
        sut.showState
            .map { $0.description }
            .emit(to: messageObserver)
            .disposed(by: disposeBag)

        // when fetching the service
        scheduler.createColdObservable([.next(1, ())])
            .map { "usingempty" }
            .bind(to: sut.searchKeyword)
            .disposed(by: disposeBag)

        scheduler.start()

        // expected params
        let expectedMessage: String = StateViewCases.empty.params.description

        // expected message
        XCTAssertEqual(messageObserver.events, [.next(1, expectedMessage)])
    }

    func test_fetchWithErrorResponse() {
        // create testable observers
        let messageObserver = scheduler.createObserver(String.self)

        // bind the result
        sut.showState
            .map { $0.description }
            .emit(to: messageObserver)
            .disposed(by: disposeBag)

        // when fetching the service
        scheduler.createColdObservable([.next(1, ())])
            .map { "usingerror" }
            .bind(to: sut.searchKeyword)
            .disposed(by: disposeBag)

        scheduler.start()

        // expected params
        let expectedMessage: String = StateViewCases.error.params.description
        XCTAssertEqual(messageObserver.events, [.next(1, expectedMessage)])
    }

    func test_fetchWithSuccess() {
        // create testable observers
        let dataObserver = scheduler.createObserver(Int.self)

        // bind the result
        sut.homeViewListSection
            .map { $0.first?.items.count ?? 0 }
            .drive(dataObserver)
            .disposed(by: disposeBag)

        // when fetching the service
        scheduler.createColdObservable([.next(1, "usingsuccess")])
            .bind(to: sut.searchKeyword)
            .disposed(by: disposeBag)

        scheduler.start()

        XCTAssertEqual(dataObserver.events, [.next(0, 0), .next(1, 6), .next(1, 10)])
    }

    func test_fetchWithCacheFound() {
        let key = "usingcachefound"
        let detailModel = MovieDetailModel(title: "Test", year: "", type: "", imdbID: "", poster: "")
        let detailModels = Array(repeating: detailModel, count: 3)
        cacheManager.add(data: CacheMovieModel(datas: detailModels), name: key)

        // create testable observers
        let dataObserver = scheduler.createObserver(Int.self)

        // bind the result
        sut.homeViewListSection
            .skip(1)
            .map { [unowned self] _ in
                self.cacheManager.get(name: key)?.datas.count ?? 0
            }.drive(dataObserver)
            .disposed(by: disposeBag)

        // when fetching the service
        scheduler.createColdObservable([.next(1, ())])
            .map { key }
            .bind(to: sut.searchKeyword)
            .disposed(by: disposeBag)

        scheduler.start()
    
        XCTAssertEqual(dataObserver.events.last!, .next(1, 3))
    }

    func test_fetchPagination() {
        // create testable observers
        let dataObserver = scheduler.createObserver(Int.self)

        // bind the result
        sut.homeViewListSection
            .map { $0.first?.items.count ?? 0 }
            .drive(dataObserver)
            .disposed(by: disposeBag)

        // when fetching page 1, the datas count should be 10
        scheduler.createColdObservable([.next(1, "usingsuccess")])
            .bind { [unowned self] terms in
                self.sut.searchKeyword.accept(terms)
                self.sut.goToNextPage.accept(())
            }
            .disposed(by: disposeBag)

        // when fetching page 2, the datas count should be 20
        scheduler.createColdObservable([.next(2, "usingsuccess")])
            .bind { [unowned self] terms in
                self.sut.searchKeyword.accept(terms)
                self.sut.goToNextPage.accept(())
            }.disposed(by: disposeBag)

        scheduler.start()

        XCTAssertEqual(dataObserver.events[2], .next(1, 10))
        XCTAssertEqual(dataObserver.events.last!, .next(2, 20))
    }

    func test_tapStateShouldTriggerResetFocus() {
        // create testable observers
        let dataObserver = scheduler.createObserver(Bool.self)

        // bind the result
        sut.resetSearchAndFocus
            .map { true }
            .emit(to: dataObserver)
            .disposed(by: disposeBag)

        // when did tapped state button
        scheduler.createColdObservable([.next(1, ())])
            .bind { [unowned self] _ in
                self.sut.searchKeyword.accept("usingempty")
                self.sut.didTappedStateButton.accept(())
            }.disposed(by: disposeBag)

        scheduler.start()

        XCTAssertEqual(dataObserver.events, [.next(1, true)])
    }

}
