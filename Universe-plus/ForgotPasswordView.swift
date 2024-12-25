//
//  ForgotPasswordView.swift
//  Univserse-PLUS
//
//  Created by Накыпов Эрмек on 13/12/24.
//

import SwiftUI
import FirebaseAuth
struct ForgotPasswordView: View {
    @State private var email: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var showSuccess: Bool = false

    var body: some View {
        ZStack {
            Image("main_space")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .allowsHitTesting(false)

            VStack(spacing: 20) {
                Text("Forgot Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                ZStack(alignment: .leading) {
                    if email.isEmpty {
                        Text("Email")
                            .foregroundColor(.white.opacity(0.6))
                            .padding(.leading, 30)
                    }
                    TextField("", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.8), lineWidth: 1)
                        )
                        .padding(.horizontal)
                }
                
                Button(action: {
                    resetPassword()
                }) {
                    Text("Send Reset Link")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                if showSuccess {
                    Text("A password reset email has been sent to your email. Please check your inbox.")
                        .foregroundColor(.green)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            .padding()
        }
    }
    
    func resetPassword() {
        if email.isEmpty {
            showError = true
            errorMessage = "Please enter your email."
            return
        }
        
        showError = false
        showSuccess = false
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                showError = true
                errorMessage = error.localizedDescription
            } else {
                showSuccess = true
                print("Password reset email sent.")
            }
        }
    }
}

