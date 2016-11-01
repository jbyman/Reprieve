//
//  CancelCall.swift
//  Reprieve-Dispatch
//
//  Created by Jake Byman on 11/1/16.
//  Copyright © 2016 Jake Byman. All rights reserved.
//

import UIKit
import CoreLocation

class CancelCall: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mainTableView: UITableView!

    static var incidents : NSMutableArray = ["Sup"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(CancelCall.incidents)
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Num things")
        return CancelCall.incidents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Cells for row stuff")
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "prototypeCell", for: indexPath)
        
        
        
        
        let dict = CancelCall.incidents[indexPath.row] as! NSDictionary
        let incidentLat = Float64(dict["latitude"] as! String)
        let incidentLong = Float64(dict["longitude"] as! String)
        
        let geocoder = CLGeocoder()
        
        // Reverse geocode to display the address of the incident, as opposed to lat/long
        let coordinate = CLLocation(latitude: incidentLat!, longitude: incidentLong!)
        geocoder.reverseGeocodeLocation(coordinate, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error!)
            }
            if (placemarks?.first) != nil {
                
                let name = placemarks?.first?.name
                let city = placemarks?.first?.locality
                let state = placemarks?.first?.administrativeArea
                let postalCode = placemarks?.first?.postalCode
                let country = placemarks?.first?.country
                
                var full = ""
                full += name! + ", " + city!
                full += ", " + state! + ", "
                full += postalCode! + ", "
                full += country!
                full += "      (Incident ID: " + (dict["incident_id"] as! String) + ")"
                
                cell.textLabel?.text = full
            
            }
        })
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Did I select stuff?")
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // Cancel dispatch
        if (editingStyle == .delete) {
            
            self.mainTableView!.beginUpdates()
            let dict = CancelCall.incidents[indexPath.row] as! NSDictionary
            let incident_id = dict["incident_id"]
            
            let ret = HTTP.httpRequest(requestType: "end_incident", parameters: ["incident_id":incident_id!])
            if ret == ""{
                print("Error cancelling incident")
            }
            
            CancelCall.incidents.removeObject(at: indexPath.row)
            mainTableView.deleteRows(at: [indexPath], with: .fade)
            
            self.mainTableView!.endUpdates()
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Cancel Dispatch"
    }

}
