//
//  PostCell.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 02.08.22.
//

import UIKit

class PostCell1: UITableViewCell {
    
    // MARK: Outlets

    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelCourseAndFaculty: UILabel!
    @IBOutlet weak var labelContent: UILabel!
    
    @IBOutlet weak var stackViewLikes: UIStackView!
    
    @IBOutlet weak var imageViewHeart: UIImageView!
    @IBOutlet weak var imageViewComment: UIImageView!
    @IBOutlet weak var imageViewShare: UIImageView!
    @IBOutlet weak var imageViewSave: UIImageView!
    
    var delegate: PostCellDelegate!
    
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
    
    // MARK: Initial Functions
    
    func configure(with post: Post) {
        
//        labelFullName.text = "\(post.author.name) \(post.author.surname)"
//        labelCourseAndFaculty.text = "\(post.author.course ?? ""), \(post.author.faculty ?? "")"
//        labelContent.text = post.content
    }
    
    func configureDesign() {
        backgroundColor = UIColor.clear
        contentView.layer.cornerRadius = 35
        contentView.layer.masksToBounds = true
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
