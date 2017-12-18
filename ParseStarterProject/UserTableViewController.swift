//
//  UserTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by WM1 on 12/4/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse
import QuartzCore

class UserTableViewController: UITableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return allTheUsers.count
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }

    var profilePic = [PFFile]()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.rowHeight = 400
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserTableViewCell
        
        if let data = profilePic[indexPath.section] as? PFFile {
            
            data.getDataInBackground(block: { (data, error) in
                
                if (error != nil) {
                    
                    print(error)
                    
                } else {
                    
                    let image = UIImage(data: data!)
                    
                    cell.userImage.image = image
                    cell.userImage.layer.borderWidth = 1
                    cell.userImage.layer.masksToBounds = false
                    cell.userImage.layer.borderColor = UIColor.white.cgColor
                    cell.userImage.layer.cornerRadius = cell.userImage.frame.height / 2
                    cell.userImage.clipsToBounds = true
                    
                }
                
            })
            
        }
        
        cell.summary.text = "About me..."
        
        cell.userLabel.text = allTheUsers[indexPath.section]
    
        if (isFollowing[userID[indexPath.section]])! {

            cell.followText.text = "Following"
        
            cell.followText.backgroundColor = UIColor.cyan
            
            cell.followText.layer.masksToBounds = true
            
            cell.followText.layer.cornerRadius = 5
            
        } else {
            
            cell.followText.text = "Follow"
            
            cell.followText.backgroundColor = UIColor.gray
            
            cell.followText.layer.masksToBounds = true
            
            cell.followText.layer.cornerRadius = 5
            
        }
        
        return cell
        
    }
    
    var allTheUsers = [String]()
    
    var userID = [String]()
    
    
    @IBAction func setting(_ sender: Any) {
        
        performSegue(withIdentifier: "toSettings", sender: self)
        
    }
    
//    @IBAction func logOut(_ sender: Any) {
//
//        PFUser.logOut()
//
//        performSegue(withIdentifier: "backToInitial", sender: self)
//    }

    @IBOutlet var tableview: UITableView!
    
    var refresher:UIRefreshControl!
    
    func refresh() {
        
        if (PFUser.current()?.username == nil) {
            
            PFUser.logOut()
            
        } else if ((PFUser.current()?.isNew) == true) {
            
            let alert = UIAlertController(title: "Incomplete user info", message: "Complete the user info right now!", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                
                self.performSegue(withIdentifier: "newUser", sender: self)
                
                PFUser.current()?.saveInBackground()
                
            }))
            
            alert.addAction(UIAlertAction(title: "Later", style: UIAlertActionStyle.default, handler: { (action) in
                
                alert.dismiss(animated: true, completion: nil)
                
            }))
            
            present(alert, animated: true, completion: nil)
     
        
        }
        
        let query = PFUser.query()
        
        query?.findObjectsInBackground(block: { (objects, error) in
            
            if (error != nil) {
                
                print(error)
                
            } else {
                
                if let users = objects {
                    
                    self.userID.removeAll()
                    self.allTheUsers.removeAll()
                    self.isFollowing.removeAll()
                    
                    for object in users {
                        
                        if let user = object as? PFUser {
                            
                            if (object.objectId != PFUser.current()?.objectId) {
                                
                                self.allTheUsers.append(user["nickname"] as! String)
                                
                                self.profilePic.append(user["profilePic"] as! PFFile)
                                
                                self.userID.append(user.objectId!)
                                
                                let newQuery = PFQuery(className: "Followers")
                                
                                newQuery.whereKey("followers", equalTo: PFUser.current()!.objectId as AnyObject)
                                
                                newQuery.whereKey("following", equalTo: user.objectId! as AnyObject)
                                
                                newQuery.findObjectsInBackground(block: { (objects, error) in
                                    
                                    if let objects = objects {
                                        
                                        if (objects.count > 0) {
                                            
                                            self.isFollowing[user.objectId!] = true
                                            
                                        } else {
                                            
                                            self.isFollowing[user.objectId!] = false
                                            
                                        }
                                        
                                    }
                                    
                                    if (self.isFollowing.count == self.allTheUsers.count) {
                                        
                                        self.tableview.reloadData()
                                        
                                        self.refresher.endRefreshing()
                                        
                                    }
                                    
                                })
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        })
        
    }
    
    @IBAction func post(_ sender: Any) {
        
        performSegue(withIdentifier: "toImage", sender: self)
        
    }
    
    
    @IBAction func discovery(_ sender: Any) {
        
        performSegue(withIdentifier: "toDiscovery", sender: self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = false
        
        refresh()
        
        refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refresher.addTarget(self, action: #selector(UserTableViewController.refresh), for: UIControlEvents.valueChanged)
        
        tableview.addSubview(refresher)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    
    
    var isFollowing = [String: Bool]()

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = self.tableview.cellForRow(at: indexPath) as! UserTableViewCell
        
        cell.contentView.backgroundColor = UIColor.white
        
        if (isFollowing[userID[indexPath.section]] == false) {
//
            cell.followText.text = "Following"
            
            cell.followText.backgroundColor = UIColor.cyan
            
            cell.followText.layer.masksToBounds = true
            
            cell.setSelected(true, animated: true)
            
            cell.followText.layer.cornerRadius = 5
            
            let following = PFObject(className: "Followers")
            
            following["followers"] = PFUser.current()?.objectId
            
            following["following"] = self.userID[indexPath.section]
            
            following.saveInBackground()
            
            self.isFollowing[self.userID[indexPath.section]] = true
        
        } else {
            
            let alert = UIAlertController(title: "Are you sure to unfollow this person?", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Unfollow", style: .default, handler: { (action) in
//
                cell.followText.text = "Follow"
                
                cell.followText.backgroundColor = UIColor.gray
                
                cell.followText.layer.masksToBounds = true
                
                cell.setSelected(true, animated: true)
                
                cell.followText.layer.cornerRadius = 5
//
                let query = PFQuery(className: "Followers")
                
                query.whereKey("followers", equalTo: PFUser.current()?.objectId!)
                
                query.whereKey("following", equalTo: self.userID[indexPath.section])
                
                query.findObjectsInBackground(block: { (objects, error) in
                    
                    if (error != nil) {
                        
                        print(error)
                        
                    } else {
                        
                        if let following = objects {
                            
                            for follow in following {
                                
                                follow.deleteInBackground()
                                
                            }
                            
                        }
                        
                    }
                    
                })
                
                self.isFollowing[self.userID[indexPath.section]] = false
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
         
        }
        
    }
    
    
    
    // MARK: - Table view data source	



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
