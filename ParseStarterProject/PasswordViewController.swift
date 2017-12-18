//
//  PasswordViewController.swift
//  ParseStarterProject-Swift
//
//  Created by WM1 on 12/13/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class PasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var oldPass: UITextField!
    
    @IBOutlet weak var newPass: UITextField!
    
    @IBOutlet weak var againPass: UITextField!
    
    @IBOutlet weak var errorText: UILabel!
    
    @IBAction func changePass(_ sender: Any) {
        
        errorText.isHidden = true
        
        if (newPass.text! == "" || (newPass.text?.count)! < 6) {
            
            errorText.text = "Please enter a password of at least 6 characters."
            
            errorText.isHidden = false
            
        } else if (newPass.text != againPass.text) {
            
            errorText.text = "Two passwords enetered do not match."
            
            errorText.isHidden = false
            
        } else {
            
            PFUser.logInWithUsername(inBackground: (PFUser.current()?.email)!, password: oldPass.text!, block: { (user, error) in
                
                if (error != nil) {
                    
                    print(error)
                    
                    self.errorText.text = "Old password entered does not match our record."
                    
                    self.errorText.isHidden = false
                    
                } else {
                    
                    let query = PFUser.query()
                    
                    query?.whereKey("username", equalTo: PFUser.current()?.username)
                    
                    query?.findObjectsInBackground(block: { (objects, error) in
                        
                        if (error != nil) {
                            
                            print(error)
                            
                        } else {
                            
                            if let users = objects {
                                
                                for user in users {
                                    
                                    user.setObject(self.newPass.text, forKey: "password")
                                    
                                    user.saveInBackground()
                                    
                                    let alert = UIAlertController(title: "Password updated.", message: "You have successfully updated the password. Please log in using the new password.", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                        
                                        self.performSegue(withIdentifier: "logOut", sender: self)
                                        
                                        PFUser.logOut()
                                        
                                    }))
                                    
                                    self.present(alert, animated: true, completion: nil)
                                  
                                }
                                
                            }
                            
                        }
                        
                    })
                
                }
                
            })
            
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        errorText.isHidden = true
        
        self.navigationItem.title = "Changing Password"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
