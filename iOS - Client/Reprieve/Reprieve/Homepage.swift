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
            print(locationManager)
        }
        else{
            print("nope")
        }
        
        let defaults = UserDefaults.standard
        let is_registered = defaults.bool(forKey: "IS_USER_REGISTERED")
        
        if (is_registered){
            print("YES the person is registered")
            registrationBtn.isHidden = true
            let firstName = defaults.string(forKey: "USER_FIRST_NAME")
            greetingLabel.isHidden = false
            greetingLabel.text = "Hello, " + firstName!
            locationManager.startUpdatingLocation()
        }
        else{
            print("not hidden")
        }
                
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            self.view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        print("Location changed")
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
            let ret = HTTP.httpRequest(requestType: "update_responder_location", parameters: ["provider_lat":latitude, "provider_long":longitude])
            if ret{
                print("Updated location")
            }
            else{
                print("Error updating location")
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("FAILURE")
        print(error)
        locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

