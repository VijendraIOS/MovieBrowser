//
//  Utility.swift
//  MovieBrowser
//
//  Created by Vijendra Vishwakarma on 22/12/18.
//  Copyright © 2018 Vijendra Vishwakarma. All rights reserved.
//

import Foundation
enum MOVIE_TYPE: String {
	
	case normal = "Normal"
	case search = "Search"
	case mostPopular = "MostPopular"
	case topRated = "TopRated"
}

class Utility {
	
	class func showAlert(in viewController:UIViewController, message:String, title:String) {
		
		let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
		let okAction = UIAlertAction(title: "OK", style: .default, handler:{
			(UIAlertAction)-> Void in		})
		
		//let cancel = UIAlertAction(title: Constant.kCANCEL, style: .default, handler: nil)
		alertController.addAction(okAction)
		alertController.view.tintColor = UIColor.red   //UIColor.white
		viewController.present(alertController, animated: true, completion: nil);
	}
	
	class func getGeneralMovieListURL(with id:Int) -> String {
		
		let urlString  = "\(kBASE_URL)list/\(id)?api_key=\(kAPI_KEY)&language=en-US"
		return urlString
	}
	
	class func getSearchMovieListURL(for pageCount:Int, keywordToSearch:String)  -> String{
		
		let urlString = "\(kBASE_URL)search/movie?api_key=\(kAPI_KEY)&language=en-US&query=\(keywordToSearch)&page=\(pageCount)&include_adult=false"
		return urlString
	}
	
	class func getMostPopularMovieListURL(for pageCount:Int) -> String {
		
		let urlString = "\(kBASE_URL)movie/popular?api_key=\(kAPI_KEY)&language=en-US&page=\(pageCount)"
		return urlString
	}
	
	class func getTopRatedMovieURL(for pageCount:Int) -> String {
		
		let urlString = "\(kBASE_URL)movie/top_rated?api_key=\(kAPI_KEY)&language=en-US&page=\(pageCount)"
		return urlString
	}
}
