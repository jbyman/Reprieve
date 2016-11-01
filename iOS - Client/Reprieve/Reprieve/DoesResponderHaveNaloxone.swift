//
//  DoesResponderHaveNaloxone.swift
//  NaloxOne
//
//  Created by Jake Byman on 10/26/16.
//  Copyright © 2016 Jake Byman. All rights reserved.
//

import UIKit

class DoesResponderHaveNaloxone: UIViewController {

    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var naloxoneSwitch: UISwitch!
    
    var firstName : String = ""
    var lastName : String = ""
    var phoneNumber : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerBtn.layer.cornerRadius = 5
        
        naloxoneSwitch.addTarget(self, action: #selector(switchDidChange), for: UIControlEvents.valueChanged)
        naloxoneSwitch.isOn = false
        registerBtn.isEnabled = false
        registerBtn.alpha = 0.3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func switchDidChange(sender: UISwitch){
        if naloxoneSwitch.isOn{
            registerBtn.isEnabled = true
            registerBtn.alpha = 1.0
        }
        else{
            registerBtn.isEnabled = false
            registerBtn.alpha = 0.3
        }
    }
    
    @IBAction func submitRegistration(_ sender: AnyObject) {
        
        let defaults = UserDefaults.standard
        
        let token = HTTP.device_token
        var formattedToken = token.replacingOccurrences(of: " ", with: "")
        formattedToken = formattedToken.replacingOccurrences(of: "<", with: "")
        formattedToken = formattedToken.replacingOccurrences(of: ">", with: "")

        let res = HTTP.httpRequest(requestType: "new_provider", parameters: ["first_name":firstName as Any, "last_name":lastName as Any, "phone_number":phoneNumber as Any, "provider_lat" : HTTP.latitude as Any, "provider_long": HTTP.longitude as Any, "device_token": formattedToken as Any])
        if res{
            print("Response went through")
            defaults.set(true, forKey: "IS_USER_REGISTERED")
            defaults.set(firstName, forKey: "USER_FIRST_NAME")
            defaults.set(lastName, forKey: "USER_LAST_NAME")
            defaults.set(phoneNumber, forKey: "USER_PHONE_NUMBER")
        }
        else{
            defaults.set(false, forKey: "IS_USER_REGISTERED")
            print("Failure")
            return
        }
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            self.view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }

}
