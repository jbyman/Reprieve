//
//  ManageCalls.swift
//  Reprieve-Dispatch
//
//  Created by Jake Byman on 11/1/16.
//  Copyright © 2016 Jake Byman. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class ManageCalls: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addCallBtn: UIButton!
    @IBOutlet weak var cancelCallBtn: UIButton!
    
    var latitude : Float64 = 0.0
    var longitude : Float64 = 0.0
    var specificIncident : Bool = false
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let defaults = UserDefaults.standard

        // Dispatcher ID is set to 1 for now!
        defaults.set("1", forKey: "DISPATCHER_ID")
        
        locationManager.requestAlwaysAuthorization()
        
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.distanceFilter = 3
            locationManager.startUpdatingLocation()
        }

        let lat = 42.439631
        let long = -76.485176
        
        self.latitude = lat
        self.longitude = long
        
        let camera = GMSCameraPosition.camera(withLatitude: self.latitude, longitude: self.longitude, zoom: 18.0)
        
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        marker.map = mapView
        
        var request = URLRequest(url: URL(string: HTTP.SERVER_URI + "retrieve_incidents&dispatcher_id=1")!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            
            if error != nil{
                print("Error!")
                print(error!);
                return
            }
            
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            if responseString != "null"{
                let incidentsArray : NSArray = self.jsonStringToNSMutableArray(text: responseString as! String)!
                let mutableArray = NSMutableArray(array: incidentsArray)
                
                CancelCall.incidents = mutableArray
                
                // Switch to main thread and plot incidents on map
                DispatchQueue.main.async {
                    for object in incidentsArray{
                        let dict = object as! NSDictionary
                        let incidentLat = Float64(dict["latitude"] as! String)
                        let incidentLong = Float64(dict["longitude"] as! String)
                        self.dropPin(pinLat: incidentLat!, pinLong: incidentLong!)
                    }
                }
            }
        }
        
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        print("Location changed")
        
        if(!specificIncident){
            let locValue: CLLocationCoordinate2D = locationManager.location!.coordinate
        
            let lat = 42.439631
            let long = -76.485176
//            let lat = locValue.latitude
//            let long = locValue.longitude
            self.latitude = lat
            self.longitude = long
            
            let update : GMSCameraUpdate = GMSCameraUpdate.setTarget(CLLocationCoordinate2DMake(lat, long))
        
            mapView.animate(with: update)
            
        }
        manager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("FAILURE")
        print(error)
        locationManager.stopUpdatingLocation()
    }
    
    func dropPin(pinLat : Float64, pinLong : Float64){
        let position = CLLocationCoordinate2DMake(pinLat, pinLong)
        let marker = GMSMarker(position: position)
        marker.title = "Suspected Opioid Overdose"
        marker.map = mapView
    }
    
    func jsonStringToNSMutableArray(text: String) -> NSArray? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? NSArray
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }

}
