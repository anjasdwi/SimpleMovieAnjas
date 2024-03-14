//
//  HomeViewListSectionModel.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 14/03/24.
//

import RxDataSources

struct HomeViewListSectionModel {
    var items: [Item]
}

extension HomeViewListSectionModel: SectionModelType {
    typealias Item = MovieCardCVCViewModel

    init(original: HomeViewListSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
