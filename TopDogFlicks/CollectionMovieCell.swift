//
//  CollectionMovieCell.swift
//  TopDogFlicks
//
//  Created by Lise Ho on 2/10/16.
//  Copyright © 2016 Lise Ho. All rights reserved.
//

import UIKit

class CollectionMovieCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        /*
        posterImage.frame.size.height = self.frame.size.height
        posterImage.frame.size.width = self.frame.size.width
        */
    }
    
}
