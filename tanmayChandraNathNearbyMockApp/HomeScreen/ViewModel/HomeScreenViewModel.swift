//
//  HomeScreenViewModel.swift
//  tanmayChandraNathNearbyMockApp
//
//  Created by Tanmay Chandra Nath on 11/05/24.
//

import Foundation

protocol HomeScreenViewControllerProtocol: AnyObject {
    func startedFetchingData()
    func gotData()
    func gotError(error: Error)
}

class HomeScreenViewModel {
    var numberOfPage = 1
    var range = UiConstants().defaultRange
    var query: String?
    var fetchedData: HomeScreenLocationListModel?
    var latitude: Double?
    var longitude: Double?
    
    func incrementCurrentPage() {
        numberOfPage += 1
        fetchData(networkRequestData: networkRequestData)
    }
    
    func updateRange(newRange: Double) {
        range = newRange
        fetchData(networkRequestData: networkRequestData)
    }
    
    
    weak var delegate: HomeScreenViewControllerProtocol?
    
    func fetchDataAfterFetchingLocation() {
        let result = fetchLocation()
        switch result {
        case .success((let lat, let lon)):
            self.latitude = lat
            self.longitude = lon
            fetchData(networkRequestData: networkRequestData)
            
        case .failure(let error):
            print(error)
        }
    }
    
    func fetchData(networkRequestData: NetworkRequestDataModel) {
        self.delegate?.startedFetchingData()
        NetworkCallHelper().getLocations(params: networkRequestData) {[weak self] (result: Result<HomeScreenLocationListModel, NetworkError>) in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                self.fetchedData = data
                self.delegate?.gotData()
            case .failure(let error):
                self.fetchedData = nil
                self.delegate?.gotError(error: error)
            }
        }
    }
    
    func fetchLocation() -> Result<(Double, Double), Error>{
        /// Code for fetching user's location
        
        return (.success((79.12, 80.12)))
    }
    
    var networkRequestData: NetworkRequestDataModel {
        NetworkRequestDataModel(numberOfItemsPerPage: UiConstants().numberOfItemsPerPage, numberOfPage: self.numberOfPage, latitude: latitude!, longitude: longitude!, range: range, query: query, clientId: UiConstants().clientId)
    }
}
