//
//  NetworkCallHelper.swift
//  tanmayChandraNathNearbyMockApp
//
//  Created by Tanmay Chandra Nath on 11/05/24.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case invalidData
    case custom(error: Error)
}

protocol NetworkCallHelperProtocol {
    func getLocations(params: NetworkRequestDataModel, completion: @escaping ((Result<HomeScreenLocationListModel, NetworkError>) -> Void))
}

class NetworkCallHelper: NetworkCallHelperProtocol {
    func getLocations(params: NetworkRequestDataModel, completion: @escaping ((Result<HomeScreenLocationListModel, NetworkError>) -> Void)) {
        guard let url = NetworkRequestHelper().createUrl(params: params) else {
            completion(.failure(.invalidUrl))
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failure(.custom(error: error)))
            }
            if let urlResponse = response as? HTTPURLResponse {
                if urlResponse.statusCode == 200 {
                    if let data = data {
                        do {
                            let decodedData = try JSONDecoder().decode(HomeScreenLocationListModel.self, from: data)
                            completion(.success(decodedData))
                        } catch {
                            completion(.failure(.invalidData))
                        }
                        
                    }
                    
                } else {
                    completion(.failure(.invalidData))
                }
            }
        }
    }
    
}


struct NetworkRequestHelper {
    func createUrl(params: NetworkRequestDataModel) -> URL? {
        let constants = NetworkConstants()
        let urlString = "\(constants.baseUrl)\(constants.perPage)\(params.numberOfItemsPerPage)&\(constants.page)\(params.numberOfPage)&\(constants.clientId)\(params.clientId)&\(constants.lat)\(params.latitude)&\(constants.lon)\(params.longitude)&\(constants.range)\(params.range)mi&\(constants.query)\(params.query ?? "")"
        return URL(string: urlString)
    }
}
