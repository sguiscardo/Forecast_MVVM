//
//  ForecastDataProvider.swift
//  Forecast_MVVM
//
//  Created by Karl Pfister on 2/15/22.
//

import Foundation

protocol ForecastSearchDataProvidable where Self: APIDataProvidable {
    func fetch(completion: @escaping (Result<ForcastData, NetworkError>) -> Void)
}

struct ForecastSearchDataProvider: ForecastSearchDataProvidable, APIDataProvidable {
    // Adopts the protocol, which we cna use for testing. We can just create another object like this to test.
    private let baseURLString = "https://api.weatherbit.io"
    
    func fetch(completion: @escaping (Result<ForcastData, NetworkError>) -> Void) {
        guard let baseURL = URL(string:baseURLString) else {return}

        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = "/v2.0/forecast/daily"
        
        let apiQuery = URLQueryItem(name: "key", value: "8503276d5f49474f953722fa0a8e7ef8")
        let cityQuery = URLQueryItem(name: "city", value:"Salt Lake")
        let unitsQuery = URLQueryItem(name: "units", value: "I")
        urlComponents?.queryItems = [apiQuery,cityQuery,unitsQuery]
        
        guard let finalURL = urlComponents?.url else {return}
        print(finalURL)
        let request = URLRequest(url: finalURL)
        
        perform(request) { result in
            switch result {
            case .success(let data):
                do {
                    let object = try data.decode(type: ForcastData.self)
                    completion(.success(object))
                } catch {
                    completion(.failure(.requestError(error)))
                }
            case .failure(let error):
                completion(.failure(.requestError(error)))
            }
        }
    }
}
