//
//  MainTabView.swift
//  Univserse-PLUS
//
//  Created by Накыпов Эрмек on 17/12/24.
//

import SwiftUI

struct MainTabView: View {
    init() {
        UITabBar.appearance().barTintColor = UIColor.black
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            NewsView()
                .tabItem {
                    Image(systemName: "newspaper.fill")
                    Text("News")
                }

            MarsPhotosView()
                .tabItem {
                    Image(systemName: "camera.fill")
                    Text("Mars Photos")
                }

            AboutView()
                .tabItem {
                    Image(systemName: "info.circle.fill")
                    Text("Profile")
                }
        }
        .accentColor(.white)
        .background(Color.black.ignoresSafeArea()) 
    }
}
