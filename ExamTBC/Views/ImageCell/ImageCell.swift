//
//  ImageCell.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 08.08.22.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewPostImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with image: UIImage) {
        imageViewPostImage.image = image
    }

}
