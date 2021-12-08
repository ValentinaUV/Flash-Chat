//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages: [Message] = []
    
    let db = Firestore.firestore()
    var firebaseManager = FirebaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebaseManager.delegate = self
        tableView.dataSource = self
        title = Constants.appName
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: Constants.receivedCellNibName, bundle: nil), forCellReuseIdentifier: Constants.receivedCellIdentifier)
        tableView.register(UINib(nibName: Constants.sentCellNibName, bundle: nil), forCellReuseIdentifier: Constants.sentCellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages() {
        firebaseManager.getMessages()
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text {
            firebaseManager.saveMessage(messageBody)
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        firebaseManager.logout()
    }
    
}

extension ChatViewController: FirebaseChatDelegate {
    
    func didLoadMessages(_ messages: [Message]) {
        self.messages = messages
        DispatchQueue.main.async {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
    
    func didSaveMessage() {
        print("Successfully saved data.")
        DispatchQueue.main.async {
            self.messageTextfield.text = ""
        }
    }
    
    func didLogoutUser() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func didFailWithError(error: Error) {
        print("Chat error")
        print(error)
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        if message.sender == firebaseManager.getCurrentUserEmail() {
            return getSentMessageCell(tableView, indexPath, message: message)
        } else {
            return getReceivedMessageCell(tableView, indexPath, message: message)
        }
    }
    
    func getSentMessageCell(_ tableView: UITableView, _ indexPath: IndexPath, message: Message) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.sentCellIdentifier, for: indexPath) as? MessageCellSent else {
            return UITableViewCell()
        }
        
        cell.label.text = message.body
        
        return cell
    }
    
    func getReceivedMessageCell(_ tableView: UITableView, _ indexPath: IndexPath, message: Message) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.receivedCellIdentifier, for: indexPath) as? MessageCellReceived else {
            return UITableViewCell()
        }

        let separated = message.sender.split(separator: "@")
        cell.leftLabel.text = String(separated.first ?? "You")
        cell.label.text = message.body
        
        return cell
    }
}
