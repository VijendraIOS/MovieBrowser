//
//  MovieDetailViewController.swift
//  MovieBrowser
//
//  Created by Vijendra Vishwakarma on 22/12/18.
//  Copyright © 2018 Vijendra Vishwakarma. All rights reserved.
//

import UIKit
/*!
	@brief: The MovieDetailViewController
	@discussion:  This class is designed and implemented to manage detail of the selected movie like title, rating, release Date and poster.
	@superclass SuperClass: UIViewController
	@classdesign: It is design for all the iPhone size.
*/
class MovieDetailViewController: UIViewController {
	
	//MARK: IBOutlets and Variables
	@IBOutlet weak var imageViewMovie: UIImageView!
	@IBOutlet weak var labelTitle: UILabel!
	@IBOutlet weak var labelUserRating: UILabel!
	@IBOutlet weak var labelReleaseDate: UILabel!
	@IBOutlet weak var labelOverview: UILabel!
	
	var currentMovie:Movies!
	
	//MARK: UIViewController's life cycle method
	override func viewDidLoad() {
		
		super.viewDidLoad()
		setDataIntoViews()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	//MARK: Methods
	/*!
		@brief It is a setDataIntoViews method
		@description This method is to set data into labels like top rating , title , release date, overview and poster of the movies.
		@param nil
	*/
	fileprivate func setDataIntoViews() {
		
		if(currentMovie != nil) {
			
			imageViewMovie.loadImageUsingCache(withUrl: currentMovie.posterImage)
			labelTitle.text = currentMovie.originalTitle
			labelUserRating.text = "\(currentMovie.rating ?? 0.0)"
			self.title = currentMovie.originalTitle
			labelReleaseDate.text = currentMovie.releaseDate
			labelOverview.text = currentMovie.overview
		}
	}
}
