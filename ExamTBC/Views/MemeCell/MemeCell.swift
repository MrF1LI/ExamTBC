//
//  MemeCell.swift
//  ExamTBC
//
//  Created by GIORGI PILISSHVILI on 02.08.22.
//

import UIKit

class MemeCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewMeme: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with meme: Meme) {
        
        let imageUrlString = meme.imageUrl
        
        imageViewMeme.sd_setImage(with: URL(string: imageUrlString),
                                              placeholderImage: UIImage(named: "photo"),
                                              options: .continueInBackground,
                                              completed: nil)
        
    }
    
}
