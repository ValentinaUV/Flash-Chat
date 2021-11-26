//
//  CloudManager.swift
//  Flash Chat iOS13
//
//  Created by Ungurean Valentina on 25.11.2021.
//

import Foundation
import Firebase

protocol FirebaseManagerDelegate {
    func didFailWithError(error: Error)
}

protocol FirebaseRegisterDelegate: FirebaseManagerDelegate {
    func didRegisterUser()
}

protocol FirebaseLoginDelegate: FirebaseManagerDelegate {
    func didLoginUser()
}

protocol FirebaseChatDelegate: FirebaseManagerDelegate {
    func didLoadMessages(_ messages: [Message])
    func didSaveMessage()
    func didLogoutUser()
}

class FirebaseManager {
    
    var delegate: FirebaseManagerDelegate?
    let db = Firestore.firestore()
    var dbListener: ListenerRegistration?
    
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
            if let listener = dbListener {
                listener.remove()
            }
            if let delegate = self.delegate as? FirebaseChatDelegate {
                delegate.didLogoutUser()
            }
        } catch let e as NSError {
            self.delegate?.didFailWithError(error: e)
        }
    }
    
    func getMessages() {
        if let _ = getCurrentUserEmail() {
            
            print("getMessages")
            var messages: [Message] = []
            
            dbListener = db.collection(Constants.FStore.collectionName)
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
    }
    
    func saveMessage(_ messageBody: String) {
        if let messageSender = getCurrentUserEmail() {
            db.collection(Constants.FStore.collectionName).addDocument(data: [
                Constants.FStore.senderField: messageSender,
                Constants.FStore.bodyField: messageBody,
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
}


