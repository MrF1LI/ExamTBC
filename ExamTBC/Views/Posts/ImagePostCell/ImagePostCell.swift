//
//  ImagePostCell.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 04.08.22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ImagePostCell: UITableViewCell {
    
    // MARK: Variables
    
    @IBOutlet weak var labelAuthorFullName: UILabel!
    @IBOutlet weak var labelCourseAndFaculty: UILabel!
    @IBOutlet weak var imageViewAuthorProfile: UIImageView!
//    @IBOutlet weak var imageViewContent: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var labelContent: UILabel!
    
    @IBOutlet weak var imageViewHeart: UIImageView!
    @IBOutlet weak var imageViewComment: UIImageView!
    @IBOutlet weak var imageViewShare: UIImageView!
    @IBOutlet weak var imageViewSave: UIImageView!
    
    @IBOutlet weak var collectionViewImages: UICollectionView!
    
    var delegate: PostCellDelegate!
        
    var arrayOfImages = [String]()
    
    // MARK: Lifecycle methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        configureDesign()
        configureButtons()
        configureCollectionView()
        configurePageControl()
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
    
    func configure(with post: ImagePost) {
                
        if let content = post.text {
            labelContent.text = content
        } else {
            labelContent.isHidden = true
        }
        
        arrayOfImages = post.images
        pageControl.numberOfPages = arrayOfImages.count
                
        FirebaseService.dbUsers.child(post.author).observe(.value) { snapshot in
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
        
        let referenceOfReacts = FirebaseService.dbPosts.child(post.id).child("reacts")
        referenceOfReacts.observeSingleEvent(of: .value) { snapshot in
            
            if snapshot.hasChild(Auth.auth().currentUser!.uid) {
                self.imageViewHeart.image = UIImage(systemName: "heart.fill")
                self.imageViewHeart.tintColor = .systemPink
            } else {
                self.imageViewHeart.image = UIImage(systemName: "heart")
                self.imageViewHeart.tintColor = .black

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
        
        let goToAuthorProfileGesture = UITapGestureRecognizer(target: self, action: #selector(actionGoToAuthorProfile))
        imageViewAuthorProfile.addGestureRecognizer(goToAuthorProfileGesture)
        
        let goToAuthorProfileGesture1 = UITapGestureRecognizer(target: self, action: #selector(actionGoToAuthorProfile))
        labelAuthorFullName.addGestureRecognizer(goToAuthorProfileGesture1)
        
    }
    
    func configureCollectionView() {
        collectionViewImages.delegate = self
        collectionViewImages.dataSource = self
        collectionViewImages.register(UINib(nibName: "PostImageCell", bundle: nil), forCellWithReuseIdentifier: "PostImageCell")
    }
    
    func configurePageControl() {
        pageControl.currentPage = 0
        pageControl.numberOfPages = arrayOfImages.count
        pageControl.isUserInteractionEnabled = false
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
    
    @objc func actionGoToAuthorProfile() {
        delegate.goToAuthorProfile(cell: self)
    }
    
}
