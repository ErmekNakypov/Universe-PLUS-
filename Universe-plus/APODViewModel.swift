//
//  APODViewModel.swift
//  Univserse-PLUS
//
//  Created by Накыпов Эрмек on 17/12/24.
//

import SwiftUI

class APODViewModel: ObservableObject {
    @Published var apods: [APOD] = []
    @Published var errorMessage: String?

    func fetchRecentAPODs(count: Int = 5) {
        let apiKey = "KEY"
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        apods = [] 

        for i in 0..<count {
            if let date = Calendar.current.date(byAdding: .day, value: -i, to: today) {
                let dateString = dateFormatter.string(from: date)
                guard let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)&date=\(dateString)") else { continue }

                URLSession.shared.dataTask(with: url) { data, _, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            self.errorMessage = "Error: \(error.localizedDescription)"
                            return
                        }
                        guard let data = data else { return }
                        if let apod = try? JSONDecoder().decode(APOD.self, from: data) {
                            self.apods.append(apod)
                            self.apods.sort { $0.date > $1.date }
                        }
                    }
                }.resume()
            }
        }
    }
}
