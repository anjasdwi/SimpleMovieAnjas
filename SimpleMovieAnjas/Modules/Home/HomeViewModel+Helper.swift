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

    /// Function for converting/formatting terms
    func termsFormatted(from text: String) -> String {
        text.isEmpty ? "man" : text.lowercased()
    }

    /// Method for check cache
    /// If there is cache datas, then show cache datas
    func cacheChecking(onNotFound: (()->Void)) {
        let lastTerm = termsFormatted(from: searchKeyword.value)
        if let cacheDatas = self.cacheManager.get(name: "\(lastTerm)\(1)")?.datas, !cacheDatas.isEmpty {
            self._homeViewListSection.accept(self.getListSection(from: cacheDatas))
        } else {
            onNotFound()
        }
    }

}
