//
//  MovieCell.swift
//  MovieBrowser
//
//  Created by Sumit Vishwakarma on 22/12/18.
//  Copyright © 2018 Sumit Vishwakarma. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var labelMovieTitle: UILabel!
    @IBOutlet weak var imageViewPoster: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
