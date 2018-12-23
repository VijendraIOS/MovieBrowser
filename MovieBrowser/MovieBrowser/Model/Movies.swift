//
//  Movies.swift
//  MovieBrowser
//
//  Created by Vijendra Vishwakarma on 22/12/18.
//  Copyright © 2018 Vijendra Vishwakarma. All rights reserved.
//

import Foundation
class Movies {
    
    var originalTitle:String!
    var posterImage:String = "https://image.tmdb.org/t/p/w342"
    var overview:String!
    var rating:Double!
    var releaseDate:String!
    
    init(json:JSON) {
        
        originalTitle = json["original_title"].string ?? ""
        let posterPath = json["poster_path"].string ?? ""
        posterImage = posterImage+posterPath
        overview = json["overview"].string ?? ""
        rating = json["vote_average"].double ?? 0.0
        releaseDate = json["release_date"].string ?? ""
    }
}

