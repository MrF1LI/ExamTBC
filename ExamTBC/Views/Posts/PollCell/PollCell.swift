//
//  PollCell.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 04.08.22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class PollCell: UITableViewCell {
    
    // MARK: Variables
    
    @IBOutlet weak var labelAuthorFullName: UILabel!
    @IBOutlet weak var labelCourseAndFaculty: UILabel!
    @IBOutlet weak var imageViewAuthorProfile: UIImageView!
    @IBOutlet weak var labelQuestion: UILabel!
    
    @IBOutlet weak var imageViewHeart: UIImageView!
    @IBOutlet weak var imageViewComment: UIImageView!
    @IBOutlet weak var imageViewShare: UIImageView!
    @IBOutlet weak var imageViewSave: UIImageView!
    
    var delegate: PostCellDelegate!
    
    var dbPosts = Database.database().reference().child("posts")
    
    // MARK: Lifecycle methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureDesign()
        configureButtons()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
    
    // MARK: Functions
    
    func configureDesign() {
        backgroundColor = UIColor.clear
        contentView.layer.cornerRadius = 35
        contentView.layer.masksToBounds = true
        imageViewAuthorProfile.layer.cornerRadius = imageViewAuthorProfile.frame.width / 2
    }
    
    func configure(with post: Poll) {
        
        labelQuestion.text = post.question
        
        let dbUsers = Database.database().reference().child("users")
        
        dbUsers.child(post.author).observe(.value) { snapshot in
            let value = snapshot.value as? NSDictionary
            
            let name = value?["name"] as? String ?? ""
            let surname = value?["surname"] as? String ?? ""
            let url = value?["profile"] as? String ?? ""
            
            let course = value?["course"] as? String ?? ""
            var faculty = value?["faculty"] as? String ?? ""
            
            if faculty == "Information Technologies" { faculty = "IT" }
            
            self.labelCourseAndFaculty.text = "\(course), \(faculty)"
            
            self.labelAuthorFullName.text = "\(name) \(surname)"
            self.imageViewAuthorProfile.sd_setImage(with: URL(string: url),
                                              placeholderImage: UIImage(named: "user"),
                                              options: .continueInBackground,
                                              completed: nil)
        }
        
        let ref = dbPosts.child(post.id).child("reacts").child(Auth.auth().currentUser!.uid)
        ref.observe(.value) { snapshot in
            if snapshot.exists() {
                self.imageViewHeart.image = UIImage(named: "heart.fill")
            } else {
                self.imageViewHeart.image = UIImage(named: "heart")
            }
        }
    }
    
    func configureButtons() {
        
        let reactGesture = UITapGestureRecognizer(target: self, action: #selector(actionReact))
        imageViewHeart.addGestureRecognizer(reactGesture)
        
        let commentGesture = UITapGestureRecognizer(target: self, action: #selector(actionComment))
        imageViewComment.addGestureRecognizer(commentGesture)
        
        let shareGesture = UITapGestureRecognizer(target: self, action: #selector(actionShare))
        imageViewShare.addGestureRecognizer(shareGesture)
        
        let saveGesture = UITapGestureRecognizer(target: self, action: #selector(actionSave))
        imageViewSave.addGestureRecognizer(saveGesture)
        
    }
    
    // MARK: Actions
    
    @objc func actionReact() {
        delegate.react(cell: self)
    }
    
    @objc func actionComment() {
        delegate.comment(cell: self)
    }
    
    @objc func actionShare() {
        delegate.share(cell: self)
    }
    
    @objc func actionSave() {
        delegate.save(cell: self)
    }
    
}
