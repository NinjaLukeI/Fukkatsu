//
//  AuthViewModel.swift
//  mangaBackend
//
//  Created by Tobi Oyebanji on 29/07/2023.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthFormProtocol {
    var formIsValid: Bool {get}
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
   
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("Debug: Failed to login with error \(error.localizedDescription)")
        }
        
    }
    
    func createUser(withEmail email: String, password: String, firstName: String, lastName: String, displayName: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, firstName: firstName, lastName: lastName, email: email, displayName: displayName)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("Debug: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut() // Signs out user in the backend
            self.userSession = nil // Removes User sessions, results in user been taken backed to login screen as userSession is a published object.
            self.currentUser = nil // removes current user data
        } catch {
            print("Debug: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() {
        
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        self.currentUser = try? snapshot.data(as: User.self)
        
        
    }
}
