//
//  HomeViewModel+Helper.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 16/03/24.
//

import Foundation

extension HomeViewModel {

    /// Function used for compose model from MovieListModel into array of HomeViewListSectionModel
    /// - Parameter models: array origin model to be composed
    func getListSection(from models: [MovieDetailModel]) -> [HomeViewListSectionModel] {
        let items = models.map {
            HomeViewItemModel
                .list(
                    viewModel: MovieCardCVCViewModel(
                        title: $0.title ?? "",
                        year: $0.year ?? "",
                        type: $0.type ?? "",
                        posterUrl: $0.poster ?? ""
                    )
                )
        }
        return [HomeViewListSectionModel(items: items)]
    }

    /// Function to get HomeViewListSectionModel for skeleton state
    func getSkeletonSection() -> [HomeViewListSectionModel] {
        let items = Array(repeating: HomeViewItemModel.skeleton, count: 6)
        return [HomeViewListSectionModel(items: items)]
    }

    /// Function to get HomeViewListSectionModel with pagination loading state
    func getSectionWithPaginationLoading() -> [HomeViewListSectionModel] {
        var existingDatas = _homeViewListSection.value
        existingDatas.append(HomeViewListSectionModel(items: [.paginationLoading]))
        return existingDatas
    }

    /// Function to get HomeViewListSectionModel without pagination loading state
    func getSectionWithoutPaginationLoading() -> [HomeViewListSectionModel] {
        guard let data = _homeViewListSection.value.first
        else { return _homeViewListSection.value }
        return [data]
    }

    /// Function for converting/formatting terms
    func termsFormatted(from text: String) -> String {
        text.isEmpty ? "man" : text.lowercased()
    }

    /// Method for check cache
    /// If there is cache datas, then show cache datas
    func cacheChecking(onFound: (([MovieDetailModel])->Void), onNotFound: (()->Void)) {
        let lastTerm = termsFormatted(from: searchKeyword.value)
        if let cacheDatas = self.cacheManager.get(name: "\(lastTerm)\(page)")?.datas, !cacheDatas.isEmpty {
            onFound(cacheDatas)
        } else {
            onNotFound()
        }
    }

    /// Method for update list section data
    func updateListSection(isFromPagination: Bool, datas: [MovieDetailModel]) {
        // Checking by origin pagination
        // if from pagination, then append new data
        // otherwise set new data
        if isFromPagination {
            self.movieDetailModels.append(contentsOf: datas)
        } else {
            self.movieDetailModels = datas
        }

        self._homeViewListSection.accept(self.getListSection(from: self.movieDetailModels))
    }

}
