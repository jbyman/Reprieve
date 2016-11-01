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
                
                let ret = HTTP.httpRequest(requestType: "new_incident", parameters: ["incident_lat" : latitudeText, "incident_long" : longitudeText, "notes": formattedNotes as Any, "dispatcher_id" : "1"])
                
                print("PRINTING RESULT")
                print(ret)
            }
        })
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
