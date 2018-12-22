//
//  Extension.swift
//  MovieBrowser
//
//  Created by Vijendra Vishwakarma on 22/12/18.
//  Copyright © 2018 Vijendra Vishwakarma. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    static func main() -> UIStoryboard {return UIStoryboard(name: kMAIN, bundle: nil)}
    static func movieDetailViewController() -> MovieDetailViewController {
        
        return main().instantiateViewController(withIdentifier: kMOVIE_DETAIL_VC_ID) as! MovieDetailViewController
    }
}

/*!
 @brief It is UIImageView Of Data.
 @discussion This extension is used for load image asynchronously.
 */

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
  
  func loadImageUsingCache(withUrl urlString : String) {
    
    guard let url = URL(string: urlString) else {
      self.image = #imageLiteral(resourceName: "aaa.jpg")
      return
    }
    self.image = nil
    // check cached image
    if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
      self.image = cachedImage
      return
    }
    // if not, download image from url
    URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
      if error != nil {
        print(error!)
        return
      }
      DispatchQueue.main.async {
        
        if let image = UIImage(data: data!) {
          imageCache.setObject(image, forKey: urlString as NSString)
          self.image = image
        }else {
          self.image = #imageLiteral(resourceName: "aaa.jpg")
        }
      }
    }).resume()
  }
  
}

