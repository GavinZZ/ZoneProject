//
//  ImageViewController.swift
//  ParseStarterProject-Swift
//
//  Created by WM1 on 12/6/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class ImageViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imageUploaded = false

    @IBAction func upload(_ sender: Any) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        picker.allowsEditing = false
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            
            picker.sourceType = UIImagePickerControllerSourceType.camera
            
            self.present(picker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default, handler: { (action) in
            
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            
            self.present(picker, animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageview.image = image
            
            imageUploaded = true
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var text: UITextField!
    
    @IBOutlet weak var imageview: UIImageView!
    
    var activity = UIActivityIndicatorView()
    
    @IBAction func submit(_ sender: Any) {
        
        if (text.text == "" || imageUploaded != true) {
            
            let alert = UIAlertController(title: "Empty Fields", message: "Please upload an image or enter some text", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
            
        } else {
        
            activity = UIActivityIndicatorView(frame: CGRect(x: 0, y: -20, width: 50, height: 50))
            
            activity.center = self.view.center
            
            activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            
            activity.hidesWhenStopped = true
            
            view.addSubview(activity)
            
            activity.startAnimating()
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            var post = PFObject(className: "Posts")
        
            post["createdDate"] = Date()
            
            post["message"] = text.text
            
            post["likes"] = 0
            
            post["peopleLiked"] = []
            
            post["tag"] = 0
            
            post["userID"] = PFUser.current()?.objectId
            
            post["nickname"] = PFUser.current()!["nickname"]
            
            post["username"] = PFUser.current()?.username
            
            let imageData = UIImageJPEGRepresentation(imageview.image!, 0.5)
            
            let imageFile = PFFile(name: "image.png", data: imageData!)
            
            post["imageFile"] = imageFile
            
            post.saveInBackground { (success, error) in
                
                if (error != nil) {
                    
                    print(error)
                    
                } else {
                    
                    let alert = UIAlertController(title: "Image Posted", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    
                    self.activity.stopAnimating()
                    
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    self.text.text = ""
                    
                    self.imageview.image = UIImage(named: "placeholder-image.png")
                    
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
    
    @objc func navigate() {
        
        performSegue(withIdentifier: "toFeed", sender: self)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageUploaded = false
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationItem.title = "Uploading image"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Discovery", style: UIBarButtonItemStyle.plain, target: self, action: #selector(navigate))

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
