//
//  ProfileTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by WM1 on 12/10/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class ProfileTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = Int(keyboardRectangle.height)
            
            print(keyboardHeight)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
//        tableView.backgroundColor = UIColor(red:0.73, green:1.00, blue:0.99, alpha:1.0)
        
        tableView.backgroundColor = UIColor.lightGray
        
        let query = PFUser.query()
        
        query?.whereKey("objectId", equalTo: PFUser.current()?.objectId)
        
        query?.findObjectsInBackground(block: { (objects, error) in
            
            if (error != nil) {
                
                print(error)
                
            } else {
                
                if let users = objects {
                    
                    for object in users {
                        
                        if let user = object as? PFUser {
                            
                            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ProfileTableViewCell
                            
                            if let picture = user["profilePic"] as? PFFile {
                                
                                picture.getDataInBackground(block: { (data, error) in
                                    
                                    if (error != nil) {
                                        
                                        print(error)
                                        
                                    } else {
                                        
                                        cell.profilePic.image = UIImage(data: data!)
                                        
                                        cell.profilePic.layer.borderWidth = 1
                                        cell.profilePic.layer.masksToBounds = false
                                        cell.profilePic.layer.borderColor = UIColor.white.cgColor
                                        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.height / 2
                                        cell.profilePic.clipsToBounds = true
                                        
                                        
                                    }
                                    
                                })
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
         
        })

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 5
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 5
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (section != 0) {
            
            let view = UIView()
            
//            view.backgroundColor = UIColor(red:0.73, green:1.00, blue:0.99, alpha:1.0)
            
            view.backgroundColor = UIColor.lightGray
            
            return view
            
        } else {
            
            let view = UIView()
            
            return view
            
        }
        
    }
    
    var activeSec = 0
    
    var activeName = ""
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProfileTableViewCell
    
        tableView.rowHeight = (self.view.frame.height - (self.navigationController?.navigationBar.frame.height)! - 30) / 5
        
        if (indexPath.section == 2) {
            
            cell.profilePic.isHidden = true
     
            cell.settingText.text = PFUser.current()?.email
            
            cell.settingText.textColor = UIColor.brown
            
            cell.textLabel?.text = "Email Address:"
            
        } else if (indexPath.section == 3) {
            
            cell.profilePic.isHidden = true
            
            cell.textLabel?.text = "Update password"
            
            cell.settingText.text = "Update now"
            
            cell.settingText.textColor = UIColor.brown
            
        } else if (indexPath.section == 0) {
            
            cell.settingText.text = "Upload an image"
            
            cell.settingText.textColor = UIColor.brown
            
        } else if (indexPath.section == 1) {
            
            cell.textLabel?.text = "Update username"
            
            cell.settingText.text = PFUser.current()?["nickname"] as! String
            
            cell.settingText.textColor = UIColor.brown
            
        } else if (indexPath.section == 4) {
            
            cell.textLabel?.text = "Update status"
            
            cell.settingText.numberOfLines = 2
            
            cell.settingText.textColor = UIColor.brown
            
            cell.settingText.text = PFUser.current()?["summary"] as? String
            
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ProfileTableViewCell
        
        cell.contentView.backgroundColor = UIColor.white
        
        if (indexPath.section == 0) {
            
            let picker = UIImagePickerController()
            
            picker.delegate = self
            
            picker.allowsEditing = true
            
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                
                picker.sourceType = UIImagePickerControllerSourceType.camera
                
                self.present(picker, animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default, handler: { (action) in
                
                picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                
                self.present(picker, animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: {
                
                alert.view.superview?.isUserInteractionEnabled = true
                alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertClose(gesture:))))
                
            })
            
        } else if (indexPath.section == 1) {
            
            activeName = "nickname"
            
            activeSec = indexPath.section
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editStart))
            
            tapGesture.numberOfTapsRequired = 1
            
            cell.addGestureRecognizer(tapGesture)
            
        } else if (indexPath.section == 3) {
            
            activeName = "password"
            
            activeSec = indexPath.section
            
            performSegue(withIdentifier: "toPass", sender: self)
            
        } else if (indexPath.section == 4) {
            
            activeSec = indexPath.section
            
            activeName = "summary"
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editStart))
            
            tapGesture.numberOfTapsRequired = 1
            
            cell.addGestureRecognizer(tapGesture)
            
        }
    
        
    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        self.view.endEditing(true)
//
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: activeSec)) as! ProfileTableViewCell
        
        let alert = UIAlertController(title: "Action Needed!", message: "Are you sure to save it? Pressing OK will replace the previous content in the selected field. Press Cancel otherwise.", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            PFUser.current()?.setObject(textField.text, forKey: self.activeName)
            
            PFUser.current()?.saveInBackground()
            
            let query = PFQuery(className: "Posts")
            
            query.whereKey("userID", equalTo: PFUser.current()?.objectId)
            
            query.findObjectsInBackground(block: { (objects, error) in
                
                if (error != nil) {
                    
                    print(error)
                    
                } else {
                    
                    if let usernames = objects {
                        
                        for username in usernames {
                            
                            username["nickname"] = textField.text
                            
                            username.saveInBackground()
                            
                        }
                        
                    }
                }
                
            })
            
            if (self.activeSec != 3) {
            
                textField.resignFirstResponder()
                
                textField.endEditing(true)
                
                textField.isHidden = true
                
                if let count = textField.text?.count {
                    
                    if (count > 42) {
                        
                        let alert = UIAlertController(title: "Summary entered is too long!", message: nil, preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                    } else {
                        
                        cell.settingText.text = textField.text
                        
                    }
                    
                }
                
            } else {
                
                textField.resignFirstResponder()
                
                textField.endEditing(true)
                
                textField.isHidden = true
                
            }
            
        }))
    
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            textField.resignFirstResponder()
            
            textField.endEditing(true)
            
            textField.isHidden = true
        }))
        
        present(alert, animated: true, completion: nil)
        
        return true
        
    }
    
    func editStart() {
        
        print(activeSec)
        
        let textField = UITextField(frame: CGRect(x: 0, y: 812 - 291, width: self.view.frame.size.width, height: 40))
        
        textField.font = UIFont.systemFont(ofSize: 14)
        
        textField.borderStyle = UITextBorderStyle.roundedRect
        
        textField.backgroundColor = UIColor.lightGray
        
        textField.autocorrectionType = UITextAutocorrectionType.no
        
        textField.keyboardType = UIKeyboardType.default
        
        textField.returnKeyType = UIReturnKeyType.done
        
        textField.clearButtonMode = UITextFieldViewMode.whileEditing;
        
        textField.becomeFirstResponder()
        
        textField.delegate = self
        
        self.view.addSubview(textField)
        
    }
    
    func alertClose(gesture: UITapGestureRecognizer) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ProfileTableViewCell
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            cell.profilePic.image = image
            cell.profilePic.layer.borderWidth = 1
            cell.profilePic.layer.masksToBounds = false
            cell.profilePic.layer.borderColor = UIColor.white.cgColor
            cell.profilePic.layer.cornerRadius = cell.profilePic.frame.height / 2
            cell.profilePic.clipsToBounds = true
            
            let imageData = UIImageJPEGRepresentation(image, 0.5)
            
            let imageFile = PFFile(name: "newProfile.jpg", data: imageData!)
            
            PFUser.current()!["profilePic"] = imageFile
            
            PFUser.current()?.saveInBackground(block: { (result, error) in
                
                if (error != nil) {
                    
                    var alert = UIAlertController(title: "Unknown Error", message: "Unable to save the profile picture.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            })
           
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
