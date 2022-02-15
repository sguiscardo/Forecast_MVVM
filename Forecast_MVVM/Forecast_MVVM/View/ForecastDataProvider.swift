//
//  ForecastDataProvider.swift
//  Forecast_MVVM
//
//  Created by Karl Pfister on 2/15/22.
//

import Foundation

protocol ForecastSearchDataProvidable where Self: APIDataProvidable {
    func fetch(from endpoint: WeatherBitEndpoint, completion: @escaping (Result<ForcastData, NetworkError>) -> Void)
}

struct ForecastSearchDataProvider: ForecastSearchDataProvidable, APIDataProvidable {
    // Adopts the protocol, which we cna use for testing. We can just create another object like this to test.
    func fetch(from endpoint: WeatherBitEndpoint, completion: @escaping (Result<ForcastData, NetworkError>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(.badURL))
            return
        }
        let request = URLRequest(url: url)
        
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

enum WeatherBitEndpoint {
    case city(String)
    
    var url: URL? {
        guard var baseURL = URL.forcastBaseURL else {return nil}
        baseURL.appendPathComponent("/v2.0/forecast")
        let apiQuery = URLQueryItem(name: "key", value: "8503276d5f49474f953722fa0a8e7ef8")
        switch self {
        case .city(let cityName):
            baseURL.appendPathComponent("daily")
            guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else { return nil}
            let cityQuery = URLQueryItem(name: "city", value:cityName)
            let unitsQuery = URLQueryItem(name: "units", value: "I")
            urlComponents.queryItems = [apiQuery,cityQuery,unitsQuery]
            return urlComponents.url
            
        }
    }
}

extension URL {
    static let forcastBaseURL = URL(string: "https://api.weatherbit.io")
}
