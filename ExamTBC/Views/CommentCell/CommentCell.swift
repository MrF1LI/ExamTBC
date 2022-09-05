//
//  CommentCell.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 04.08.22.
//

import UIKit
import FirebaseDatabase

class CommentCell: UITableViewCell {
    
    @IBOutlet weak var imageViewAuthorProfile: UIImageView!
    @IBOutlet weak var labelAuthorFullName: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    
    @IBOutlet weak var viewCommentBackground: UIView!
        
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
        viewCommentBackground.layer.cornerRadius = 25
        imageViewAuthorProfile.layer.cornerRadius = imageViewAuthorProfile.frame.width / 2
    }
    
    func configure(with comment: Comment) {
        
        labelContent.text = comment.content
        
        FirebaseService.dbUsers.child(comment.author).observe(.value) { snapshot in
            
            let value = snapshot.value as? NSDictionary
            
            let name = value?["name"] as? String ?? ""
            let surname = value?["surname"] as? String ?? ""
            
            self.labelAuthorFullName.text = "\(name) \(surname)"
            
            let url = value?["profile"] as? String ?? ""
            self.imageViewAuthorProfile.sd_setImage(with: URL(string: url),
                                                    placeholderImage: UIImage(named: "user"),
                                                    options: .continueInBackground,
                                                    completed: nil)
            
        }
        
    }
    
}
