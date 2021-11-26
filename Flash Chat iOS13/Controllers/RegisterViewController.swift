//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    var firebaseManager = FirebaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebaseManager.delegate = self
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            firebaseManager.createUser(withEmail: email, password: password)
        }
    }
}

extension RegisterViewController: FirebaseRegisterDelegate {
    
    func didRegisterUser() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: Segues.registerSegue, sender: self)
        }
    }
    
    func didFailWithError(error: Error) {
        print("Register error")
        print(error.localizedDescription)
    }
}
