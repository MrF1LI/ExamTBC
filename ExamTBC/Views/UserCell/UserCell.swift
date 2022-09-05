//
//  UserCell.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 09.08.22.
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageViewProfile.layer.cornerRadius = imageViewProfile.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configure(with user: User) {
        imageViewProfile.sd_setImage(with: URL(string: user.profilePicture ?? ""),
                                          placeholderImage: UIImage(named: "user"),
                                          options: .continueInBackground,
                                          completed: nil)
        
        labelFullName.text = "\(user.name) \(user.surname)"
        labelEmail.text = user.email
    }
    
}
