//
//  APIDataProvidable.swift
//  Forecast_MVVM
//
//  Created by Karl Pfister on 2/15/22.
//

import Foundation

protocol APIDataProvidable {
    func perform(_ request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void)
}
// WHy do we do this? So that we can use multiple endpoints and not repeat the dataTask code. This will nto change.
extension APIDataProvidable {
    func perform(_ request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestError(error)))
            }
            if let response = response as? HTTPURLResponse {
                print("\(response.statusCode)")
            }
            guard let data = data else {
                completion(.failure(.couldNotUnwrap))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
