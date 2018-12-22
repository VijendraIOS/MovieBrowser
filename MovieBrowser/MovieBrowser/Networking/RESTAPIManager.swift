//
//  RESTAPIManager.swift
//  MovieBrowser
//
//  Created by Vijendra Vishwakarma on 22/12/18.
//  Copyright © 2018 Vijendra Vishwakarma. All rights reserved.
//

import Foundation
import UIKit

//MARK: TypeAlias
typealias ServiceResponse = (JSON, NSError?) -> Void
class RESTAPIManager: NSObject {
    
    // MARK: Perform GET request
    class func makeHTTPGETRequest(_ path: String, onCompletion: @escaping ServiceResponse) {
        
        let request = URLRequest(url: URL(string: path)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            
            if let jsonData = data {
                do {
                    
                    let json:JSON = try JSON(data: jsonData)
                    onCompletion(json, error as NSError?)
                }catch {
                    
                }
            } else {
                print("http request Me json.null")
                onCompletion(JSON.null, error as NSError?)
            }
        })
        task.resume()
    }
    
    //MARK: Perform POST Request
    class func makeHTTPPOSTRequest(_ path: String, body: [String: AnyObject],onCompletion: @escaping ServiceResponse) {
        
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = "POST"
        do {
            
            // Set the POST body for the request
            let jsonBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            let headers = ["content-type": "application/x-www-form-urlencoded","cache-control": "no-cache"]
            request.allHTTPHeaderFields = headers
            request.httpBody = jsonBody
            let session = URLSession.shared
            
            let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                
                if let jsonData = data
                {
                    do {
                        let json:JSON = try JSON(data: jsonData)
                        let string = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                        if(string != "") {
                            onCompletion(json, nil)
                        }else {
                            print("Me json.null")
                            onCompletion(JSON.null, error as NSError?)
                            return
                        }
                    }catch {
                        
                    }
                    //let string = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
                    
                } else {
                    print("Me json.null-2")
                    onCompletion(JSON.null, error as NSError?)
                    return
                }
            })
            task.resume()
        }catch
        {
        }
    }
}
































