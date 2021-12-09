//
//  CloudManager.swift
//  Flash Chat iOS13
//
//  Created by Ungurean Valentina on 25.11.2021.
//

import Foundation
import Firebase

protocol FirebaseDelegate {
    func didFailWithError(error: Error)
}

protocol FirebaseRegisterDelegate: FirebaseDelegate {
    func didRegisterUser()
}

protocol FirebaseLoginDelegate: FirebaseDelegate {
    func didLoginUser()
}

protocol FirebaseChatDelegate: FirebaseDelegate {
    func didLoadMessages(_ messages: [Message])
    func didSaveMessage()
    func didLogoutUser()
}

var firebaseListener: ListenerRegistration?

class FirebaseAuth: CloudAuth {
    var delegate: FirebaseDelegate?
    
    func createUser(withEmail email: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error {
                self.delegate?.didFailWithError(error: e)
            } else {
                if let delegate = self.delegate as? FirebaseRegisterDelegate {
                    delegate.didRegisterUser()
                }
            }
        }
    }
    
    func login(withEmail email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let e = error {
                self.delegate?.didFailWithError(error: e)
            } else {
                if let delegate = self.delegate as? FirebaseLoginDelegate {
                    delegate.didLoginUser()
                }
            }
        }
    }
    
    func getCurrentUserEmail() -> String? {
        return Auth.auth().currentUser?.email
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            if let listener = firebaseListener {
                listener.remove()
            }
            if let delegate = self.delegate as? FirebaseChatDelegate {
                delegate.didLogoutUser()
            }
        } catch let e as NSError {
            self.delegate?.didFailWithError(error: e)
        }
    }
}

class FirebaseMessages: CloudMessages {
    
    var delegate: FirebaseDelegate?
    let db = Firestore.firestore()
    
    func getMessages(byEmail email: String) {
        
        print("getMessages")
        var messages: [Message] = []
        
        firebaseListener = db.collection(Constants.FStore.collectionName)
            .order(by: Constants.FStore.dateField)
            .addSnapshotListener { querySnapshot, error in
                messages = []
                
                if let e = error {
                    self.delegate?.didFailWithError(error: e)
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let messageSender = data[Constants.FStore.senderField] as? String, let messageBody = data[Constants.FStore.bodyField] as? String {
                                let newMessage = Message(sender: messageSender, body: messageBody)
                                messages.append(newMessage)
                                
                                if let delegate = self.delegate as? FirebaseChatDelegate {
                                    delegate.didLoadMessages(messages)
                                }
                            }
                        }
                    }
                }
        }
    }
    
    func saveMessage(email: String, body: String) {
        db.collection(Constants.FStore.collectionName).addDocument(data: [
            Constants.FStore.senderField: email,
            Constants.FStore.bodyField: body,
            Constants.FStore.dateField: Date().timeIntervalSince1970
        ]) { error in
            if let e = error {
                self.delegate?.didFailWithError(error: e)
            } else {
                if let delegate = self.delegate as? FirebaseChatDelegate{
                    delegate.didSaveMessage()
                }
            }
        }
    }
}
