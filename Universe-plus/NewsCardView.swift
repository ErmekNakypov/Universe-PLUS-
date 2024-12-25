//
//  NewsCardView.swift
//  Univserse-PLUS
//
//  Created by Накыпов Эрмек on 19/12/24.
//

import SwiftUI

struct NewsCardView: View {
    let item: NASAItem

    var body: some View {
        
        VStack(alignment: .leading) {

            AsyncImage(url: URL(string: item.thumbnailUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 150)
                    .cornerRadius(10)
            } placeholder: {
                ZStack {
                    Color.black.frame(height: 150).cornerRadius(10)
                    if item.mediaType == "video" {
                        Image(systemName: "play.circle")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                    }
                }
            }

            Text(item.title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 5)


            Text(item.description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }
}


