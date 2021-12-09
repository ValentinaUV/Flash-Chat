//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    var authManager = AuthManager(cloudAuth: FirebaseAuth())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authManager.cloudAuth.delegate = self
    }

    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let passwd = passwordTextfield.text {
            authManager.login(withEmail: email, password: passwd)
        }
    }
}

extension LoginViewController: FirebaseLoginDelegate {
    
    func didLoginUser() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: Segues.loginSegue, sender: self)
        }
    }
    
    func didFailWithError(error: Error) {
        print("Login error")
        print(error.localizedDescription)
    }
}
