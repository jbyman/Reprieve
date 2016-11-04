//
//  AddCall.swift
//  Reprieve-Dispatch
//
//  Created by Jake Byman on 11/1/16.
//  Copyright © 2016 Jake Byman. All rights reserved.
//

import UIKit
import CoreLocation

class AddCall: UIViewController {

    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var notesField: UITextField!
    @IBOutlet weak var dispatchBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        defaults.set("1", forKey: "DISPATCHER_ID")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dispatch(_ sender: Any) {
        
        let geocoder = CLGeocoder()
        let address = addressField.text
        
        geocoder.geocodeAddressString(address!, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error!)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                let latitudeText = String(format: "%f", coordinates.latitude)
                let longitudeText = String(format: "%f", coordinates.longitude)

                let notes = self.notesField.text
                let formattedNotes = notes?.replacingOccurrences(of: " ", with: "%20")
                
                let defaults = UserDefaults.standard
                let dispatcherID = defaults.string(forKey: "DISPATCHER_ID")! as String
            
                var urlString = HTTP.SERVER_URI
                urlString += "new_incident"
                urlString += "&incident_lat=" + latitudeText
                urlString += "&incident_long=" + longitudeText
                urlString += ("&notes=" + formattedNotes!)
                urlString += ("&dispatcher_id=" + dispatcherID)
                
                print(urlString)
                var request = URLRequest(url: URL(string: urlString)!)
                request.httpMethod = "GET"
                
                let task = URLSession.shared.dataTask(with: request){
                    data, response, error in
                    
                    if error != nil{
                        print("Error!")
                        print(error!);
                        return
                    }
                    
                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    
                    // Dispatch after 15 minutes (60 seconds * 15)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 60*15) {
                        HTTP.httpRequest(requestType: "end_incident", parameters: ["incident_id": responseString!])
                    }
                    
                    DispatchQueue.main.async {
                        if responseString != "-1"{
                            let alertController = UIAlertController(title: "Dispatched", message: "The suspected opioid overdose has been dispatched", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }
                        else{
                            let alertController = UIAlertController(title: "Error", message: "Something went wrong with dispatching", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
                print("hello")
                
                task.resume()

                
                
            }
        })
        
    }
    
    

    @IBAction func textField(_ sender: AnyObject) {
        self.view.endEditing(true);
    }

}
