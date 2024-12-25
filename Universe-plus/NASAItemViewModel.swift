//
//  NASAItemViewModel.swift
//  Univserse-PLUS
//
//  Created by Накыпов Эрмек on 19/12/24.
//

import SwiftUI

class NASAItemViewModel: ObservableObject {
    @Published var items: [NASAItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var searchQuery: String = ""
    @Published var currentPage: Int = 1

    private let pageSize = 20

    func fetchItems(reset: Bool = false) {
        guard !isLoading else { return }
        isLoading = true

        if reset {
            items = []
            currentPage = 1
        }

        let query = searchQuery.isEmpty ? "space" : searchQuery
        let urlString = "https://images-api.nasa.gov/search?q=\(query)&media_type=image,video&page=\(currentPage)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = "Error fetching items: \(error.localizedDescription)"
                    return
                }

                guard let data = data else { return }
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let collection = json["collection"] as? [String: Any],
                       let items = collection["items"] as? [[String: Any]] {
                        let newItems = items.compactMap { NASAItem(json: $0) }
                        self.items.append(contentsOf: newItems)
                        self.currentPage += 1
                    }
                } catch {
                    self.errorMessage = "Error decoding items: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
