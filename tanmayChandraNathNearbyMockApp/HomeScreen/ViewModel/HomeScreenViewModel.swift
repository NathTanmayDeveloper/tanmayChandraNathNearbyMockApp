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
    private var numberOfPage = 1
    private var range = UiConstants().defaultRange
    private var query: String?
    var fetchedData: HomeScreenLocationListModel?
    private var latitude: Double?
    private var longitude: Double?
    
    func incrementCurrentPage() {
        numberOfPage += 1
        fetchData(networkRequestData: networkRequestData)
    }
    
    func updateRange(newRange: Double) {
        range = newRange
        fetchData(networkRequestData: networkRequestData)
    }
    
    func updateQuery(newQuery: String) {
        query = newQuery
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
    
    private func fetchData(networkRequestData: NetworkRequestDataModel) {
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
    
    private func fetchLocation() -> Result<(Double, Double), Error>{
        /// Code for fetching user's location
        
        return (.success((12.971599, 77.594566)))
    }
    
   private var networkRequestData: NetworkRequestDataModel {
        NetworkRequestDataModel(numberOfItemsPerPage: UiConstants().numberOfItemsPerPage, numberOfPage: self.numberOfPage, latitude: latitude!, longitude: longitude!, range: range, query: query, clientId: UiConstants().clientId)
    }
}
