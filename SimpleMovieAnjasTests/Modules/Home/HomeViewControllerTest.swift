//
//  HomeViewControllerTest.swift
//  SimpleMovieAnjasTests
//
//  Created by Anjas Dwi on 17/03/24.
//

import XCTest
import RxTest
import RxSwift
@testable import SimpleMovieAnjas

class HomeViewControllerTest: XCTestCase {

    // MARK: Data members
    private var sut: HomeViewController!
    private var mockViewModel: HomeViewModelInterface!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!

    // MARK: Overrides
    override func setUp() {
        super.setUp()
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
        self.mockViewModel = HomeViewModelMock()
        self.sut = HomeViewController.create(withViewModel: mockViewModel)
        self.sut.loadViewIfNeeded()
    }

    override func tearDown() {
        self.sut = nil
        self.disposeBag = nil
        self.mockViewModel = nil
        self.scheduler = nil
        super.tearDown()
    }
}

// MARK: - Test Methods
extension HomeViewControllerTest {

    func test_didLoadEventShoulTriggerUpdateViews() {
        // create testable observers
        let eventObserver = scheduler.createObserver(Bool.self)

        // bind the result
        mockViewModel.updateViewsSignal
            .map { true }
            .do(afterNext: { [unowned self] status in
                XCTAssertEqual(sut.title, "Home")
            })
            .emit(to: eventObserver)
            .disposed(by: disposeBag)

        scheduler.createColdObservable([.next(1, ())])
            .bind(to: mockViewModel.viewDidLoad)
            .disposed(by: disposeBag)

        scheduler.start()

        XCTAssertEqual(eventObserver.events, [.next(1, true)])
    }

    func test_didTapStateShoulTriggerResetTextOnTextfield() {
        self.sut.mainView.searchBarView.searchTextField.text = "test"

        // create testable observers
        let eventObserver = scheduler.createObserver(Bool.self)

        // bind the result
        mockViewModel.resetSearchAndFocus
            .map { true }
            .do(afterNext: { [unowned self] status in
                XCTAssertEqual(self.sut.mainView.searchBarView.searchTextField.text, "")
            })
            .emit(to: eventObserver)
            .disposed(by: disposeBag)

        scheduler.createColdObservable([.next(1, ())])
            .bind(to: mockViewModel.didTappedStateButton)
            .disposed(by: disposeBag)

        scheduler.start()

        XCTAssertEqual(eventObserver.events, [.next(1, true)])
    }

}
