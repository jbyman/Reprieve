//
//  UpdateProfile.swift
//  NaloxOne
//
//  Created by Jake Byman on 10/26/16.
//  Copyright © 2016 Jake Byman. All rights reserved.
//

import UIKit

class UpdateProfile: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var unregisterBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var updateProfileBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateProfileBtn.layer.cornerRadius = 5
        backBtn.layer.cornerRadius = 5
        unregisterBtn.layer.cornerRadius = 5
        
        let defaults = UserDefaults.standard
        
        firstName.text = defaults.string(forKey: "USER_FIRST_NAME")
        lastName.text = defaults.string(forKey: "USER_LAST_NAME")
        phoneNumber.text = defaults.string(forKey: "USER_PHONE_NUMBER")
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
    
    @IBAction func update_users(){
        
        let defaults = UserDefaults.standard
        let provider_id = defaults.integer(forKey: "USER_DEVICE_TOKEN")
        
        let response = HTTP.httpRequest(requestType: "update_provider_information", parameters: ["first_name":firstName.text! as Any, "last_name":lastName.text! as Any, "phone_number":phoneNumber.text! as Any, "provider_id" : provider_id])
        print(response)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "homepage") as! Homepage
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func unregister(){
        print("Unregistering")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "unregistered") as! Unregistered
        print(HTTP.device_token)
        
        let token = HTTP.device_token
        var formattedToken = token.replacingOccurrences(of: " ", with: "")
        formattedToken = formattedToken.replacingOccurrences(of: "<", with: "")
        formattedToken = formattedToken.replacingOccurrences(of: ">", with: "")
        
        let _ = HTTP.httpRequest(requestType: "unregister", parameters: ["device_token" : formattedToken])
        
        print("Presenting view control")
        self.present(vc, animated: true, completion: nil)
    }

}
