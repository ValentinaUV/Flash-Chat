//
//  MessagesManager.swift
//  Flash Chat iOS13
//
//  Created by Ungurean Valentina on 09.12.2021.
//

import Foundation

protocol CloudMessages {
    var delegate: FirebaseDelegate? {get set}
    
    func getMessages(byEmail email: String)
    func saveMessage(email: String, body: String)
}

struct MessagesManager {
    
    var cloudMessages: CloudMessages
    
    func getMessages(byEmail email: String) {
        cloudMessages.getMessages(byEmail: email)
    }
    
    func saveMessage(email: String, body: String) {
        cloudMessages.saveMessage(email: email, body: body)
    }
}
