//
//  DayDetailViewModel.swift
//  Forecast_MVVM
//
//  Created by Sebastian Guiscardo on 3/8/23.
//

import Foundation

protocol DayDetailViewModelDelegate: DayDetailsViewController {
    func updateViews()
}

class DayDetailViewModel {
    
    // MARK: - Properties
    var forecastData: TopLevelDictionary?
    var days: [Day] { forecastData?.days ?? [] }
    private weak var delegate: DayDetailViewModelDelegate?
    private let networkingController: NetworkingContoller
    
    init(delegate: DayDetailViewModelDelegate, networkingController: NetworkingContoller = NetworkingContoller()) {
        self.delegate = delegate
        self.networkingController = networkingController
        self.fetchForecastData()
    }
    
    // MARK: - Functions
    func fetchForecastData() {
        NetworkingContoller.fetchDays { result in
            switch result {
            case .success(let topLevelDictionary):
                self.forecastData = topLevelDictionary
                self.delegate?.updateViews()
            case .failure(let error):
                print(error.errorDescription ?? NetworkError.unknownError)
                
            }
        }
    }
}
