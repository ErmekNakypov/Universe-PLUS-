//
//  HomeView.swift
//  Univserse-PLUS
//
//  Created by Накыпов Эрмек on 17/12/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var apodViewModel = APODViewModel()

    var body: some View {
        ZStack {
            Image("main_space")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                Text("Astronomy Picture of the Day")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()

                if apodViewModel.apods.isEmpty {
                    ProgressView("Loading...")
                        .foregroundColor(.white)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(apodViewModel.apods, id: \.url) { apod in
                                VStack(spacing: 10) {
                                   
                                    AsyncImage(url: URL(string: apod.url)) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(10)
                                            .shadow(radius: 10)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 300, height: 200)

                        
                                    Text(apod.title)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)

                                    Text(apod.date)
                                        .font(.caption)
                                        .foregroundColor(.gray)

                                    ScrollView {
                                        Text(apod.explanation)
                                            .foregroundColor(.white.opacity(0.8))
                                            .multilineTextAlignment(.leading)
                                            .font(.body)
                                            .padding()
                                    }
                                    .frame(height: 100)
                                }
                                .frame(width: 300)
                                .padding()
                                .background(Color.black.opacity(0.6))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                Spacer()
            }
            .onAppear {
                apodViewModel.fetchRecentAPODs() 
            }
        }
    }
}
