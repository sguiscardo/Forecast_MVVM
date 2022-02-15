//
//  Data+Extension.swift
//  Forecast_MVVM
//
//  Created by Karl Pfister on 2/15/22.
//

import Foundation
extension Data {
    func decode<T: Decodable>(type: T.Type, decoder: JSONDecoder = JSONDecoder()) throws -> T {
        do {
            return try decoder.decode(type.self, from: self)
        } catch {
            throw error
        }
    }
}
