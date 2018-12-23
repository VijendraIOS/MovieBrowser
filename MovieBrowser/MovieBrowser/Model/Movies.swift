//
//  Movies.swift
//  MovieBrowser
//
//  Created by Vijendra Vishwakarma on 22/12/18.
//  Copyright © 2018 Vijendra Vishwakarma. All rights reserved.
//

import Foundation
/*adult" : false,
"poster_path" : "\/rzRwTcFvttcN1ZpX2xv4j3tSdJu.jpg",
"backdrop_path" : "\/r9DmhMfsndC8QtrXKyad3KCRdcC.jpg",
"genre_ids" : [
28,
12,
35,
14,
878
],
"vote_count" : 9287,
"overview" : "Thor is on the other side of the universe and finds himself in a race against time to get back to Asgard to stop Ragnarok, the prophecy of destruction to his homeworld and the end of Asgardian civilization, at the hands of an all-powerful new threat, the ruthless Hela.",
"original_title" : "Thor: Ragnarok",
"popularity" : 48.927999999999997,
"release_date" : "2017-10-25",
"id" : 284053,
"video" : false,
"original_language" : "en",
"vote_average" : 7.5,
"title" : "Thor: Ragnarok",
"media_type" : "movie"
},*/
class Movies {
    
    var originalTitle:String!
    var posterImage:String = "https://image.tmdb.org/t/p/w342"
    var overview:String!
    var rating:Double!
    var releaseDate:String!
    
    init(json:JSON) {
      
      originalTitle     = json["original_title"].string ?? ""
      posterImage   = posterImage+json["poster_path"].string! ?? ""
      overview        = json["overview"].string ?? ""
      rating            = json["vote_average"].double ?? 0.0
      releaseDate   = json["release_date"].string ?? ""
    }
}

