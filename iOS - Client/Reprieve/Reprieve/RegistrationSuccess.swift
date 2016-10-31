//
//  RegistrationSuccess.swift
//  NaloxOne
//
//  Created by Jake Byman on 10/23/16.
//  Copyright © 2016 Jake Byman. All rights reserved.
//

import UIKit

class RegistrationSuccess: UIViewController {

    @IBOutlet weak var finishBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        finishBtn.layer.cornerRadius = 5

        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "IS_USER_REGISTERED")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            self.view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }

}
