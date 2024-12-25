//
//  MarsRoverViewModel.swift
//  Univserse-PLUS
//
//  Created by Накыпов Эрмек on 17/12/24.
//

import SwiftUI

class MarsPhotosViewModel: ObservableObject {
    @Published var photos: [MarsPhoto] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    let apiKey = "KEY"
    
    func fetchPhotos(rover: String, sol: Int?, earthDate: String?, camera: String?, page: Int) {
        isLoading = true
        errorMessage = nil
        
        var urlComponents = URLComponents(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/\(rover)/photos")!
        
        var queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "page", value: String(page))
        ]
        
        if let sol = sol {
            queryItems.append(URLQueryItem(name: "sol", value: String(sol)))
        } else if let earthDate = earthDate {
            queryItems.append(URLQueryItem(name: "earth_date", value: earthDate))
        }
        
        if let camera = camera, !camera.isEmpty {
            queryItems.append(URLQueryItem(name: "camera", value: camera))
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            self.errorMessage = "Invalid URL"
            self.isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode([String: [MarsPhoto]].self, from: data)
                    self?.photos = result["photos"] ?? []
                } catch {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }.resume()
    }
}

