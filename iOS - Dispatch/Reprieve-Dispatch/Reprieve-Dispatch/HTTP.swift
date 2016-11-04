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
    static var SERVER_URI : String = "http://104.131.100.28:8000?request_name="
    
    static func httpRequest(requestType : NSString, parameters : NSDictionary) -> NSString {
    
        var urlString = SERVER_URI + (requestType as String)
        for (k,v) in parameters{
            urlString += "&" + ((k as! NSString) as String)
            urlString += "=" + ((v as! NSString) as String)
        }
        
        print(urlString)
        
        var request = URLRequest(url: URL(string:urlString)!)
        request.httpMethod = "GET"
        
        var res : NSString = ""
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            
            if error != nil{
                print("Error!")
                print(error!);
                return
            }
            
           let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
           res = responseString!
        }
        
        task.resume()
        
        return res
    }
}
