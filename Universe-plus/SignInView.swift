//
//  SignInView.swift
//  Univserse-PLUS
//
//  Created by Накыпов Эрмек on 13/12/24.
//

import SwiftUI
import FirebaseAuth

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var navigateToVerification = false
    @State private var navigateToMainView = false


    var body: some View {
        NavigationView {
            ZStack {
                Image("main_space")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
        
                VStack(spacing: 20) {
                    Text("Welcome to Universe PLUS+")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    ZStack(alignment: .leading) {
                        if email.isEmpty {
                            Text("Email")
                                .foregroundColor(.white.opacity(0.6))
                                .padding(.leading, 30)
                        }
                        TextField("Email", text: $email)
                            .keyboardType(.asciiCapable)
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
                    
                    ZStack(alignment: .leading) {
                        if password.isEmpty {
                            Text("Password")
                                .foregroundColor(.white.opacity(0.6))
                                .padding(.leading, 30)
                        }
                        SecureField("Password", text: $password)
                            .textContentType(.newPassword)
                            .keyboardType(.asciiCapable)
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
                        signIn()
                    }) {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    NavigationLink("Don't have an account? Sign Up", destination: SignUpView())
                        .foregroundColor(.white)
                    NavigationLink("Forgot Password?", destination: ForgotPasswordView())
                        .foregroundColor(.white)
                    NavigationLink("", destination: VerificationView(), isActive: $navigateToVerification)
                        .hidden()
                    NavigationLink("", destination: MainTabView(), isActive: $navigateToMainView)
                        .hidden()
                    
                    if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }   .navigationBarBackButtonHidden(true)
    }

    func signIn() {
        if email.isEmpty || password.isEmpty {
            showError = true
            errorMessage = "Please enter both email and password."
            return
        }
        
        showError = false
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                showError = true
                errorMessage = error.localizedDescription
            } else if let user = authResult?.user {
                if user.isEmailVerified {
                    showError = false
                    print("User signed in and email is verified: \(user.email ?? "Unknown")")
                    navigateToMainView = true
                } else {
                    showError = true
                    errorMessage = "Your email is not verified. Please check your inbox."
                    
                    user.sendEmailVerification { error in
                        if let error = error {
                            print("Error sending verification email: \(error.localizedDescription)")
                        } else {
                            navigateToVerification = true
                            print("Verification email resent.")
                        }
                    }
                }
            }
        }
    }
}
