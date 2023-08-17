//
//  SignUpView.swift
//  mangaBackend
//
//  Created by Tobi Oyebanji on 29/07/2023.
//

import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var displayName = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel

    
    var body: some View {
        VStack{
            // image
            Image("anime_test_logopng")
                .resizable()
                .scaledToFill()
                .frame(width: 100,height: 120)
                .padding(.vertical,20)
            
            //Sign up form fields
            
            //form fields
            VStack (spacing: 20){
                InputView(text: $firstName, title: "First Name", placeholder: "Please enter your first name")
                
                InputView(text: $lastName, title: "Last Name", placeholder: "Please enter your last name")
                
                InputView(text: $displayName, title: "Display Name", placeholder: "Please enter a display name")
                
                InputView(text: $email,
                          title: "Email Address",
                          placeholder: "name@example.com")
                .autocapitalization(.none)
                
                InputView(text: $password,
                          title: "Password",
                          placeholder: "Please enter your password",
                          isSecureField: true)
                
                ZStack (alignment: .trailing){
                    InputView(text: $confirmPassword,
                              title: "Confirm Password",
                              placeholder: "Please confirm your password",
                              isSecureField: true)
                    
                    if !password.isEmpty && !confirmPassword.isEmpty {
                        if password == confirmPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemRed))
                        }
                    }
                }
                
                Button{
                    Task{
                        try await viewModel.createUser(withEmail: email,
                                                       password: password,
                                                       firstName: firstName,
                                                       lastName: lastName,
                                                       displayName: displayName)
                    }

                }label: {
                    HStack{
                        Text("Sign Up")
                            .fontWeight(.semibold)
                        Image("right_arrow")
                            .resizable()
                            .frame(width: 32,height: 32)
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemBlue))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top,24)
            }
            .padding(.horizontal)
            .padding(.top, 12)
        
            
        
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                    HStack(spacing: 3){
                        Text("Already have an account?")
                        Text("Login")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
            }

            
        }
        
        
        
    }
}

// AuthFormProtocol


extension SignUpView: AuthFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
        && !firstName.isEmpty
        && !lastName.isEmpty
        && !displayName.isEmpty
        
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
