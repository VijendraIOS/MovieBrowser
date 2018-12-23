//
//  MovieCell.swift
//  MovieBrowser
//
//  Created by Vijendra Vishwakarma on 22/12/18.
//  Copyright © 2018 Vijendra Vishwakarma. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var labelMovieTitle: UILabel!
    @IBOutlet weak var imageViewPoster: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
	
	/*!
		@brief It is a configureCell method
		@description This method is to set value into label and imageview for the movie.
		@param nil
	*/
	func configureCell(with movie:Movies) {
		
		self.labelMovieTitle.text = movie.originalTitle
		let url = movie.posterImage
		self.imageViewPoster.loadImageUsingCache(withUrl: url)
	}
}
