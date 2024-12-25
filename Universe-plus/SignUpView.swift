//
//  SignUpView.swift
//  Univserse-PLUS
//
//  Created by Накыпов Эрмек on 13/12/24.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var navigateToSignIn: Bool = false
    @State private var navigateToVerification = false

    var body: some View {
            ZStack {
                Image("main_space")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                
                VStack(spacing: 20) {
                    Text("Create Your Account")
                        
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
                    
                    ZStack(alignment: .leading) {
                        if confirmPassword.isEmpty {
                            Text("Confirm Password")
                                .foregroundColor(.white.opacity(0.6))
                                .padding(.leading, 30)
                        }
                        SecureField("Confirm Password", text: $confirmPassword)
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
                        signUp()
                    }) {
                        Text("Sign Up")
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
                    NavigationLink("Already have an account? Sign In", destination: SignInView())
                        .foregroundColor(.white)
                    NavigationLink("", destination: VerificationView(), isActive: $navigateToVerification)
                        .hidden()
                }
                .padding()
            }.navigationBarBackButtonHidden(true)
    }

    func signUp() {
        if email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            showError = true
            errorMessage = "Please fill in all fields."
        } else if password != confirmPassword {
            showError = true
            errorMessage = "Passwords do not match."
        } else {
            showError = false
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    showError = true
                    errorMessage = error.localizedDescription
                } else {
                    showError = false
                    print("User registered")
                    authResult?.user.sendEmailVerification(completion: { error in
                               if let error = error {
                                   print("Error sending email verification: \(error.localizedDescription)")
                                   showError = true
                                   errorMessage = "Failed to send verification email."
                               } else {
                                   print("Verification email sent.")
                                   navigateToVerification = true
                               }
                        })
                }
            }
        }
    }
}

