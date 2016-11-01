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

    static var incidents : NSArray = ["Sup"]
    
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
        
        
        let coordinate = CLLocation(latitude: incidentLat!, longitude: incidentLong!)
        geocoder.reverseGeocodeLocation(coordinate, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error!)
            }
            if (placemarks?.first) != nil {
                
                print(placemarks)
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
                
                cell.textLabel?.text = full
            
            }
        })
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Did I select stuff?")
        
    }

}
