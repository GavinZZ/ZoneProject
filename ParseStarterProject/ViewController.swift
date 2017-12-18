/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse
import SwiftMailgun

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBAction func forgot(_ sender: Any) {
    }
    
    @IBOutlet weak var forgotLabel: UIButton!
    
    var activity = UIActivityIndicatorView()
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0 {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    var signUpMode = false

    @IBOutlet weak var nickname: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var password: UITextField!

    @IBOutlet weak var signupOrLogin: UIButton!
    
    @IBOutlet weak var LogIn: UIButton!
    
    @IBOutlet weak var alreadyHave: UILabel!
    
    func textFieldDidBeginEditing(_ textField: UITextField) { // became first responder
        
        //move textfields up
        let myScreenRect: CGRect = UIScreen.main.bounds
        let keyboardHeight : CGFloat = 300
        
        UIView.beginAnimations( "animateView", context: nil)
        var movementDuration:TimeInterval = 0.35
        var needToMove: CGFloat = 0
        
        var frame : CGRect = self.view.frame
        if (textField.frame.origin.y + textField.frame.size.height + UIApplication.shared.statusBarFrame.size.height > (myScreenRect.size.height - keyboardHeight - 30)) {
            needToMove = (textField.frame.origin.y + textField.frame.size.height + UIApplication.shared.statusBarFrame.size.height) - (myScreenRect.size.height - keyboardHeight - 30);
        }
        
        frame.origin.y = -needToMove
        self.view.frame = frame
        UIView.commitAnimations()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //move textfields back down
        UIView.beginAnimations( "animateView", context: nil)
        var movementDuration:TimeInterval = 0.35
        var frame : CGRect = self.view.frame
        frame.origin.y = 0
        self.view.frame = frame
        UIView.commitAnimations()
    }
    
    func createAlert(title: String, message: String) {
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func signup(_ sender: Any) {
        
        errorLabel.text = ""

        if (signUpMode) {
        
            if (!isValidEmailAddress(emailAddressString: email.text as! String)) {
            
                errorLabel.text = "Please enter valid email address."
                
                errorLabel.isHidden = false
                
            } else if (password.text! == "" || (password.text?.count)! < 6) {
                
                errorLabel.text = "Please enter a password of at least 6 characters."
                
                errorLabel.isHidden = false
                
            } else if ((nickname.text?.count)! >  12 || (nickname.text?.count)! < 4){
                
                errorLabel.text = "Please enter a nick name between 4 to 12 characters."
                
                errorLabel.isHidden = false
                
            } else {
                
                activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                
                activity.center = self.view.center
                
                activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                
                activity.hidesWhenStopped = true
                
                view.addSubview(activity)
                
                UIApplication.shared.beginIgnoringInteractionEvents()
                
                let newUser = PFUser()
                
                newUser["nickname"] = nickname.text
                
                newUser["newUser"] = true
                
                let image = UIImage(named: "images.png")
                
                let imageData = UIImageJPEGRepresentation(image!, 0.5)
                
                let imageFile = PFFile(name: "profile.jpg", data: imageData!)
                
                newUser["profilePic"] = imageFile
                
                newUser.username = email.text
                
                newUser.email = email.text
                
                newUser.password = password.text
                
                newUser.signUpInBackground(block: { (success, error) in
                    
                    if (error != nil) {

                        self.createAlert(title: "Sign Up Error!", message: (error?.localizedDescription)!)
                        
                    } else {
                        
                        print("User signed up")
                  
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                        
                    }
                    
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                })
                
            }
                
        } else {
        
            forgotLabel.isHidden = true
    
            if (email.text == "") {
                
                errorLabel.text = "Enter your email address."
                
                errorLabel.isHidden = false
                
            } else if (password.text == "") {
                
                errorLabel.text = "Enter your password."
                
                errorLabel.isHidden = false
                
            } else {
                
                activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                
                activity.center = self.view.center
                
                activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                
                activity.hidesWhenStopped = true
                
                view.addSubview(activity)
                
                UIApplication.shared.beginIgnoringInteractionEvents()
               
                PFUser.logInWithUsername(inBackground: email.text!, password: password.text!, block: { (user, error) in
                    
                    if (error != nil) {
                        
                        self.createAlert(title: "Log In Error!", message: (error?.localizedDescription)!)
                        
                    } else {
                        
                        print("Logged in")
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                        
                    }
                    
                    UIApplication.shared.endIgnoringInteractionEvents()

                })
                
            }

        }
        
    }
    
    @IBAction func login(_ sender: Any) {
        
        if (signUpMode) {
            
            nickname.isHidden = true
            
            forgotLabel.isHidden = false
            
            signUpMode = false
            
            signupOrLogin.setTitle("Log In", for: [])
            
            LogIn.setTitle("Sign Up", for: [])
            
            alreadyHave.text = "Do not have an account?"
            
        } else {
            
            nickname.isHidden = false
            
            forgotLabel.isHidden = true
            
            signUpMode = true
            
            signupOrLogin.setTitle("Sign Up", for: [])
            
            LogIn.setTitle("Log In", for: [])
            
            alreadyHave.text = "Already have an account?"
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        
//        PFUser.logOut()
//
        if (PFUser.current()?.username != nil) {

            performSegue(withIdentifier: "showUserTable", sender: self)

        }
        
        self.navigationController?.navigationBar.isHidden = true
        
        forgotLabel.isHidden = false
        
        errorLabel.isHidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickname.isHidden = true
        
        signupOrLogin.setTitle("Log In", for: [])
        
        LogIn.setTitle("Sign up", for: [])
        
        alreadyHave.text = "Do not have an account?"

        self.navigationController?.navigationBar.isHidden = true
        
        forgotLabel.isHidden = false
        
        errorLabel.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
