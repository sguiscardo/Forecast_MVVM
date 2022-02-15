//
//  DayDetailViewModel.swift
//  Forecast_MVVM
//
//  Created by Karl Pfister on 2/13/22.
//

import Foundation

protocol DayDetailViewDelegate: DayDetailsViewController {
    func forecastResultsLoadedSuccessfully()
    func encountered(_ error: Error)
}

class DayDetailViewModel {
    //MARK: - Properties
    private var dataProvider: ForecastSearchDataProvidable
    var forcastData: ForcastData?
    var days: [Day] {
        self.forcastData?.days ?? []
    }
    private weak var delegate: DayDetailViewDelegate?
    
    // Replaces NC with Protocol
    init(delegate: DayDetailViewDelegate, dataProvider: ForecastSearchDataProvidable = ForecastSearchDataProvider()) {
        self.delegate = delegate
        self.dataProvider = dataProvider
        loadResults()
    }
    
    func loadResults() {
        dataProvider.fetch { [weak self] result in
            self?.handle(result)
        }
    }
    
    private func handle(_ result: Result<ForcastData, NetworkError>) {
        DispatchQueue.main.async {
            switch result {
            case .success(let forcastData):
                self.forcastData = forcastData
                self.delegate?.forecastResultsLoadedSuccessfully()
            case .failure(let error):
                print("Error fetching the data!", error.localizedDescription)
                self.delegate?.encountered(error)
            }
        }
    }
}
