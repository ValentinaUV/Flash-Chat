//
//  Constants.swift
//  Flash Chat iOS13
//
//  Created by Ungurean Valentina on 18.11.2021.
//

struct Constants {
    static let appName = "⚡️FlashChat"
    static let receivedCellIdentifier = "ReceivedMessageCell"
    static let receivedCellNibName = "MessageCellReceived"
    static let sentCellIdentifier = "SentMessageCell"
    static let sentCellNibName = "MessageCellSent"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}

struct Segues {
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
}
