//
//  HomeViewListSectionModel.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 14/03/24.
//

import RxDataSources

enum HomeViewItemModel {
    case list(viewModel: MovieCardCVCViewModel)
    case skeleton
    case paginationLoading
}

struct HomeViewListSectionModel {
    var items: [Item]
}

extension HomeViewListSectionModel: SectionModelType {
    typealias Item = HomeViewItemModel

    init(original: HomeViewListSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
