//
//  ViewController.swift
//  NaloxOne
//
//  Created by Jake Byman on 10/16/16.
//  Copyright © 2016 Jake Byman. All rights reserved.
//

import UIKit
import CoreLocation

class Homepage: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var registrationBtn: UIButton!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var aboutBtn: UIButton!
    @IBOutlet weak var greetingLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        greetingLabel.isHidden = true
        profileBtn.isHidden = true
        
        profileBtn.layer.cornerRadius = 5
        registrationBtn.layer.cornerRadius = 5
        aboutBtn.layer.cornerRadius = 5
        
        
        locationManager.requestAlwaysAuthorization()
                
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.distanceFilter = 3
            locationManager.startUpdatingLocation()
        }
        
        let defaults = UserDefaults.standard
        let is_registered = defaults.bool(forKey: "IS_USER_REGISTERED")
        
        if (is_registered){
            registrationBtn.isHidden = true
            let firstName = defaults.string(forKey: "USER_FIRST_NAME")
            greetingLabel.isHidden = false
        
            greetingLabel.text = "Hello, " + firstName!
            locationManager.startUpdatingLocation()
            
            profileBtn.isHidden = false
        }
        else{
    
        }
                
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            self.view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let locValue: CLLocationCoordinate2D = locationManager.location!.coordinate
        
        let latitude = String(locValue.latitude)
        let longitude = String(locValue.longitude)
        
        IncidentLocation.myLat = Float64(latitude)
        IncidentLocation.myLong = Float64(longitude)
        
        HTTP.latitude = latitude
        HTTP.longitude = longitude
        
        //Check if user is registered
        let defaults = UserDefaults.standard
        let is_registered = defaults.bool(forKey: "IS_USER_REGISTERED")
        
        if (is_registered){
            _ = HTTP.httpRequest(requestType: "update_responder_location", parameters: ["provider_lat":latitude, "provider_long":longitude])
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

