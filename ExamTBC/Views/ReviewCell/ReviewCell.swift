//
//  ReviewCell.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 01.08.22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ReviewCell: UITableViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var imageViewAuthor: UIImageView!
    @IBOutlet weak var labelAuthorFullName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelReview: UILabel!
    
    @IBOutlet weak var lecturerRating: CosmosView!
            
    // MARK: Lifecycle methods

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
        imageViewAuthor.layer.cornerRadius = imageViewAuthor.frame.width / 2
        lecturerRating.isUserInteractionEnabled = false
    }
    
    func configure(with review: Review) {
        labelReview.text = review.text
        labelDate.text = review.date
        
        let referenceOfRates = FirebaseService.dbLecturers.child(review.lecturer!).child("rates")
        
        referenceOfRates.child(review.author).observeSingleEvent(of: .value) { snapshot in
            let value = snapshot.value as? Double ?? 0
            self.lecturerRating.rating = value
        }
        
        FirebaseService.dbUsers.child(review.author).observeSingleEvent(of: .value) { snapshot in
            let value = snapshot.value as? NSDictionary
            
            let firstName = value?["name"] as? String ?? ""
            let lastName = value?["surname"] as? String ?? ""
            
            let url = value?["profile"] as? String ?? ""
            
            self.labelAuthorFullName.text = "\(firstName) \(lastName)"
            
            self.imageViewAuthor.sd_setImage(with: URL(string: url),
                                             placeholderImage: UIImage(named: "user"),
                                             options: .continueInBackground,
                                             completed: nil)
            
        }
                
    }
    
}
