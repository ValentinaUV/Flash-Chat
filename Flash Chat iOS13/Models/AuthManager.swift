//
//  AuthManager.swift
//  Flash Chat iOS13
//
//  Created by Ungurean Valentina on 09.12.2021.
//

import Foundation

protocol CloudAuth {
    var delegate: FirebaseDelegate? {get set}
    
    func createUser(withEmail email: String, password: String)
    func login(withEmail email: String, password: String)
    func getCurrentUserEmail() -> String?
    func logout()
}

struct AuthManager {
    
    var cloudAuth: CloudAuth
    
    func createUser(withEmail email: String, password: String) {
        cloudAuth.createUser(withEmail: email, password: password)
    }
    
    func login(withEmail email: String, password: String) {
        cloudAuth.login(withEmail: email, password: password)
    }
    
    func getCurrentUserEmail() -> String? {
        return cloudAuth.getCurrentUserEmail()
    }
    
    func logout() {
        cloudAuth.logout()
    }
}
