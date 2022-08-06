//
//  LecturerCell.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 01.08.22.
//

import UIKit

class LecturerCell: UITableViewCell {

    @IBOutlet weak var imageViewLecturer: UIImageView!
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelSubject: UILabel!
    @IBOutlet weak var labelRating: UILabel!

    @IBOutlet weak var lecturerRating: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure() {
        imageViewLecturer.layer.cornerRadius = imageViewLecturer.frame.width / 2
        lecturerRating.isUserInteractionEnabled = false
    }
    
    func setInformation(lecturer: Lecturer) {
        labelFullName.text = "\(lecturer.name) \(lecturer.surname)"
        labelSubject.text = lecturer.subject
        labelRating.text = String(format: "%.1f", lecturer.rating)
        lecturerRating.rating = Double(lecturer.rating)
        
        self.imageViewLecturer.sd_setImage(with: URL(string: lecturer.profileImage),
                                           placeholderImage: UIImage(named: "user"),
                                           options: .continueInBackground,
                                           completed: nil)
        
    }
    
}
