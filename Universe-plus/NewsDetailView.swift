//
//  NewsDetailView.swift
//  Univserse-PLUS
//
//  Created by Накыпов Эрмек on 19/12/24.
//

import SwiftUI
import AVKit

struct NewsDetailView: View {
    let item: NASAItem

    var body: some View {
        
        ScrollView {
            VStack(spacing: 20) {
                if item.mediaType == "video" {
                    VideoPlayerView(collectionUrl: item.collectionUrl)
                } else {
                    AsyncImage(url: URL(string: item.thumbnailUrl)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 250)
                }

                Text(item.title)
                    .font(.largeTitle)
                    .foregroundColor(.white)

                Text(item.description)
                    .foregroundColor(.white.opacity(0.8))
                    .padding()
            }
            .padding()
        }
        .background(Color.black.ignoresSafeArea())
    }
}



struct VideoPlayerView: View {
    let collectionUrl: String
    @State private var videoUrl: String?
    @State private var isError: Bool = false

    var body: some View {
        Group {
            if let videoUrl = videoUrl, let url = URL(string: videoUrl) {
                VideoPlayer(player: AVPlayer(url: url))
                    .frame(height: 250)
                    .cornerRadius(10)
            } else if isError {
                Text("Unable to load video")
                    .foregroundColor(.red)
            } else {
                ProgressView("Loading video...")
                    .onAppear {
                        fetchVideoUrl(from: collectionUrl) { url in
                            DispatchQueue.main.async {
                                if let url = url {
                                    self.videoUrl = url
                                } else {
                                    self.isError = true
                                }
                            }
                        }
                    }
            }
        }
    }

    func fetchVideoUrl(from collectionUrl: String, completion: @escaping (String?) -> Void) {
        print("Fetching video URL from: \(collectionUrl)")

        guard let url = URL(string: collectionUrl) else {
            print("Invalid collection URL")
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching collection: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received from collection")
                completion(nil)
                return
            }

            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [String] {
                    print("Fetched collection: \(jsonArray)")

                    if let videoUrl = jsonArray.first(where: { $0.contains("~orig.mp4") }) {
                        completion(videoUrl)
                    } else if let videoUrl = jsonArray.first(where: { $0.contains("~preview.mp4") }) {
                        completion(videoUrl)
                    } else {
                        print("No suitable video URL found")
                        completion(nil)
                    }
                } else {
                    print("Invalid JSON structure")
                    completion(nil)
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}
