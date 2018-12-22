//
//  MovieDetailViewController.swift
//  MovieBrowser
//
//  Created by Vijendra Vishwakarma on 22/12/18.
//  Copyright © 2018 Vijendra Vishwakarma. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

  @IBOutlet weak var imageViewMovie: UIImageView!
  @IBOutlet weak var labelTitle: UILabel!
  @IBOutlet weak var labelUserRating: UILabel!
  @IBOutlet weak var labelReleaseDate: UILabel!
  @IBOutlet weak var labelOverview: UILabel!
  
  var currentMovie:Movies!
  
  override func viewDidLoad() {
        
        super.viewDidLoad()
        setDataIntoViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  func setDataIntoViews() {
    
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
