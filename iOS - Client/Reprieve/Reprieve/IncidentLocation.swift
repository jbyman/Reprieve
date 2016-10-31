//
//  IncidentLocation.swift
//  NaloxOne
//
//  Created by Jake Byman on 10/26/16.
//  Copyright © 2016 Jake Byman. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class IncidentLocation: UIViewController {

    
    @IBOutlet weak var ignoreBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    var latitude : Float64 = 0.0
    var longitude : Float64 = 0.0
    var notes : String = ""
    var incidentId : String = ""
    
    static var myLat : Float64?
    static var myLong : Float64?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ignoreBtn.layer.cornerRadius = 5
        confirmBtn.layer.cornerRadius = 5
        notesLabel.text = notes
        
        let camera = GMSCameraPosition.camera(withLatitude: self.latitude, longitude: self.longitude, zoom: 18.0)
        
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        marker.map = mapView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            self.view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    
    @IBAction func acceptDispatch(_ sender: AnyObject) {
        
        let _ = HTTP.httpRequest(requestType: "provider_accepts", parameters: ["device_token":HTTP.device_token as Any, "incident_id":incidentId])
        
        displayInMaps()
    }
    
    func displayInMaps(){
        let url = NSURL(string:"http://maps.apple.com/?saddr=\(IncidentLocation.myLat!),\(IncidentLocation.myLong!)&daddr=\(latitude),\(longitude)")!
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }

}
