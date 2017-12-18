//
//  SendViewController.swift
//  ParseStarterProject-Swift
//
//  Created by WM1 on 12/8/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse
import SwiftMailgun
import QuartzCore

class SendViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedtext.layer.cornerRadius = 6
        
        feedtext.layer.masksToBounds = true

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var feedtext: UITextView!
    
    @IBAction func send(_ sender: Any) {
        
        let mailgun = MailgunAPI(apiKey: "key-e3a9a7ce9366dd13c87a28e5c4697ea3", clientDomain: "sandbox3cd39471612d49008b92557c0c24b0dd.mailgun.org")
        
        if let feed = feedtext.text {
            
            if (feed.count > 0) {
        
                mailgun.sendEmail(to: "hz351086153@gmail.com", from: PFUser.current()?.email as! String, subject: "User Feedback", bodyHTML: "<b>" + feedtext.text! + "<b>") { (result) in
                    
                    if (result.success) {
                        
                        print("Email was sent")
                        
                        let alert = UIAlertController(title: "Email Sent Successfully!", message: nil, preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                }
                
            }
            
        }

        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
