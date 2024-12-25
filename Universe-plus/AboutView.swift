//
//  AboutView.swift
//  Univserse-PLUS
//
//  Created by Накыпов Эрмек on 17/12/24.
//

import SwiftUI
import FirebaseAuth

struct AboutView: View {
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var navigateToSignIn = false

    var body: some View {
        NavigationView {
            ZStack {
                Image("main_space")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Profile")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    if let user = Auth.auth().currentUser {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Email: \(user.email ?? "Unknown")")
                                .foregroundColor(.white)
                                .font(.headline)

                            Text("Email Verified: \(user.isEmailVerified ? "Yes" : "No")")
                                .foregroundColor(user.isEmailVerified ? .green : .red)
                                .font(.subheadline)
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                    } else {
                        Text("No user logged in")
                            .foregroundColor(.red)
                            .font(.headline)
                    }

                    Spacer()

                    Button(action: {
                        signOut()
                    }) {
                        Text("Log Out")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.red)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }

                    if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    }

                    NavigationLink("", destination: SignInView(), isActive: $navigateToSignIn)
                        .hidden()
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
    }


    func signOut() {
        do {
            try Auth.auth().signOut()
            navigateToSignIn = true
        } catch {
            showError = true
            errorMessage = error.localizedDescription
        }
    }
}

