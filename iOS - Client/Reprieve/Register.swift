//
//  Register.swift
//  NaloxOne
//
//  Created by Jake Byman on 10/22/16.
//  Copyright © 2016 Jake Byman. All rights reserved.
//

import UIKit

class Register: UIViewController {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backBtn.layer.cornerRadius = 5
        nextBtn.layer.cornerRadius = 5
        
        firstName.autocapitalizationType = .words
        lastName.autocapitalizationType = .words
        
        // Do any additional setup after loading the view.
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
    
    
    @IBAction func checkFields(){
        if firstName.text != "" && lastName.text != "" && phoneNumber.text != ""{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "doesResponderHaveNaloxone") as! DoesResponderHaveNaloxone
            vc.firstName = firstName.text!
            vc.lastName = lastName.text!
            vc.phoneNumber = phoneNumber.text!
                        
            self.present(vc, animated: true, completion: nil)

        }
        else{
            let alertController = UIAlertController(title: "Error", message: "Please fill in all fields", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // Become first responder...get it??
        textField.resignFirstResponder()
        
        
        // becomeFirstResponder...get it?
        if (textField == self.firstName){
            self.lastName.becomeFirstResponder()
        }
        else if(textField == self.lastName){
            self.phoneNumber.becomeFirstResponder()
        }
        else if(textField == self.phoneNumber){
            // self.phoneNumber.becomeFirstResponder()
        }
        return true
    }
    
    @IBAction func textField(_ sender: AnyObject) {
        self.view.endEditing(true);
    }
    

}
