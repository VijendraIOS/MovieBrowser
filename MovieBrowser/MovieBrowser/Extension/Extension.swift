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
