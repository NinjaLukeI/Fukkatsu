//
//  LoginView.swift
//  mangaBackend
//
//  Created by Tobi Oyebanji on 29/07/2023.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationView{
            VStack{
                // image
                Image("anime_test_logopng")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100,height: 120)
                    .padding(.vertical,32)
                //form fields
                VStack (spacing: 23){
                    InputView(text: $email,
                              title: "Email Address",
                              placeholder: "name@example.com")
                    .autocapitalization(.none)
                    
                    InputView(text: $password,
                              title: "Password",
                              placeholder: "Please enter your password",
                              isSecureField: true)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                //sign in button
                
                Button{
                    Task{
                        try await viewModel.signIn(withEmail: email, password: password)
                    }
                } label: {
                    HStack{
                        Text("Sign In")
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
                
                Spacer()
                
                //sign up button
                
                NavigationLink{
                    SignUpView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3){
                        Text("Don't have an account?")
                        Text("Sign up")
                    }
                    .font(.system(size: 14))
                }
                
                
            }
        }
    }
}

// AuthFormProtocol


extension LoginView: AuthFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
