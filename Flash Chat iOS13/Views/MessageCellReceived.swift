//
//  MessageCellReceived.swift
//  Flash Chat iOS13
//
//  Created by Ungurean Valentina on 18.11.2021.
//

import UIKit

class MessageCellReceived: UITableViewCell {

    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var userBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5
        userBubble.layer.cornerRadius = userBubble.frame.size.height / 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
