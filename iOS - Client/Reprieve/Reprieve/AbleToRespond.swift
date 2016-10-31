//
//  AbleToRespond.swift
//  NaloxOne
//
//  Created by Jake Byman on 10/26/16.
//  Copyright © 2016 Jake Byman. All rights reserved.
//

import UIKit
import GoogleMaps

class AbleToRespond: UIViewController {

    @IBOutlet weak var unable: UIButton!
    @IBOutlet weak var able: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        unable.layer.cornerRadius = 5
        able.layer.cornerRadius = 5
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
