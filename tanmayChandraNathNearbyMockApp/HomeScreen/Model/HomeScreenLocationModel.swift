//
//  HomeScreenLocationModel.swift
//  tanmayChandraNathNearbyMockApp
//
//  Created by Tanmay Chandra Nath on 11/05/24.
//

import Foundation

struct HomeScreenLocationListModel: Decodable {
    let venues: [HomeScreenLocationModel]?
}

struct HomeScreenLocationModel: Decodable {
    let name, address, url: String?
}

struct NetworkRequestDataModel {
    let numberOfItemsPerPage, numberOfPage, range: Int
    let latitude, longitude: Double
    let query: String?
    let clientId: String
}
