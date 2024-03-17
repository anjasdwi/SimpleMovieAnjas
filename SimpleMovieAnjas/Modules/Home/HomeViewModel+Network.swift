//
//  HomeViewModel+Network.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 17/03/24.
//

import Foundation

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
