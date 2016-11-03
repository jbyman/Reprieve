//
//  Unregistered.swift
//  NaloxOne
//
//  Created by Jake Byman on 10/26/16.
//  Copyright © 2016 Jake Byman. All rights reserved.
//

import UIKit

class Unregistered: UIViewController {

    @IBOutlet weak var homeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeBtn.layer.cornerRadius = 5
        
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "IS_USER_REGISTERED")
        defaults.set("", forKey: "USER_FIRST_NAME")
        defaults.set("", forKey: "USER_LAST_NAME")
        defaults.set("", forKey: "USER_PHONE_NUMBER")
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

}
