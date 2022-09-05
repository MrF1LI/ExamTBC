//
//  ReceivedMessageCell.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 10.08.22.
//

import UIKit

class ReceivedMessageCell: UITableViewCell {

    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var messageBackground: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureDesign()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureDesign() {
        messageBackground.layer.cornerRadius = 20
    }
    
    func configure(with message: Message) {
        labelMessage.text = message.content
    }
}
