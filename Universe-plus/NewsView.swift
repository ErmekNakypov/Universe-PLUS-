//
//  NewsView.swift
//  Univserse-PLUS
//
//  Created by Накыпов Эрмек on 19/12/24.
//

import SwiftUI

struct NewsView: View {
    @StateObject private var viewModel = NASAItemViewModel()
    @State private var selectedItem: NASAItem? = nil

    var body: some View {
        NavigationView {
            
            VStack {
                TextField("Search...", text: $viewModel.searchQuery, onCommit: {
                    viewModel.fetchItems(reset: true)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                ZStack {
                    Color.black.ignoresSafeArea()

                    if viewModel.isLoading && viewModel.items.isEmpty {
                        ProgressView("Loading...")
                    } else if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 15) {
                                ForEach(viewModel.items) { item in
                                    NewsCardView(item: item)
                                        .onTapGesture {
                                            selectedItem = item
                                        }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("News")
            .sheet(item: $selectedItem) { item in
                NewsDetailView(item: item) 
            }
            .onAppear {
                viewModel.fetchItems()
            }
        }
    }
}
