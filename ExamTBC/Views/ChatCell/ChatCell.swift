//
//  ChatCell.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 10.08.22.
//

import UIKit
import FirebaseAuth

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var imageViewChat: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelLastMessage: UILabel!
    
    var currentUesr = Auth.auth().currentUser!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureDesign()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(with chat: Chat) {
        
        labelTitle.text = chat.title
        
        imageViewChat.sd_setImage(with: URL(string: chat.image ?? ""),
                              placeholderImage: UIImage(named: "user"),
                              options: .continueInBackground,
                              completed: nil)
        
        guard let lastMessage = chat.lastMessage else { return }
        
        print("---", lastMessage.sender, lastMessage.content)

        if lastMessage.sender == currentUesr.uid {
            labelLastMessage.text = "You: " + lastMessage.content
        } else {
            labelLastMessage.text = lastMessage.content
        }
        
    }
    
    func configureDesign() {
        imageViewChat.layer.cornerRadius = imageViewChat.frame.width / 2
    }
    
}
