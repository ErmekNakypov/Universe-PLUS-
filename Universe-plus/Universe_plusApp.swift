//
//  Universe_plusApp.swift
//  Universe-plus
//
//  Created by Накыпов Эрмек on 19/12/24.
//

import SwiftUI
import Firebase

@main
struct Univserse_plusApp: App {
    init() {
            FirebaseApp.configure()
        }
    var body: some Scene {
        WindowGroup {
            SignInView()
        }
    }
}
