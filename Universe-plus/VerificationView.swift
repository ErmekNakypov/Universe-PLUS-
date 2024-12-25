//
//  VerificationView.swift
//  Univserse-PLUS
//
//  Created by Накыпов Эрмек on 13/12/24.
//

import SwiftUI
import FirebaseAuth

struct VerificationView: View {
    @State private var isEmailVerified = false

    var body: some View {
        VStack(spacing: 20) {
            if isEmailVerified {
                Text("Your email has been successfully verified!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .multilineTextAlignment(.center)
                    .padding()
                
                NavigationLink("", destination: MainTabView(), isActive: $isEmailVerified)
                    .hidden()
            }
            else {
                Text("Verify Your Email")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("A verification email has been sent to your email address. Please check your inbox and click the link to verify your account.")
                    .multilineTextAlignment(.center)
                    .padding()

            }
        }
        .padding()
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
                checkEmailVerification()
            }
        }
    }

    func checkEmailVerification() {
        Auth.auth().currentUser?.reload { error in
            if let error = error {
                print("Error reloading user: \(error.localizedDescription)")
            } else if Auth.auth().currentUser?.isEmailVerified == true {
                isEmailVerified = true
                print("Email is verified!")
            } else {
                print("Email is not verified yet.")
            }
        }
    }
}

