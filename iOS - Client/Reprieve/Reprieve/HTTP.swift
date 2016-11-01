//
//  HTTP.swift
//  NaloxOne
//
//  Created by Jake Byman on 10/23/16.
//  Copyright © 2016 Jake Byman. All rights reserved.
//

import Foundation

class HTTP{
    
    static var latitude : String = ""
    static var longitude : String = ""
    static var device_token : String = ""
    
    static func httpRequest(requestType : NSString, parameters : NSDictionary) -> Bool {
    
        var urlString = "http://104.131.100.28:8000?request_name=" + (requestType as String)
//        var urlString = "http://localhost:8000?request_name=" + (requestType as String)
        for (k,v) in parameters{
            urlString += "&" + ((k as! NSString) as String)
            urlString += "=" + ((v as! NSString) as String)
        }
        
        var request = URLRequest(url: URL(string:urlString)!)
        request.httpMethod = "GET"
        
        var err = false
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            
            if error != nil{
                print("Error!")
                print(error!);
                err = true
                return
            }
            
           let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
           print(responseString!)
        }
        
        task.resume()
        
        if err{
            return false
        }

        return true;
    }
}
