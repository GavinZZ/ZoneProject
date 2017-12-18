//
//  FeedTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by WM1 on 12/7/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

//extension UIView {
//    func fadeIn() {
//        // Move our fade out code from earlier
//        self.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
//        UIView.animate(withDuration: 2, animations: {
//            self.frame = CGRect(x: 0, y: 85, width: 265, height: 278)
//        })
//    }
//
//    func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 2.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
//
//        UIView.animate(withDuration: 2, animations: {
//            self.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
//        })
//
//    }
//}

class FeedTableViewController: UITableViewController{
    
    var count = 0
    
    var objectID = [String]()
    
    var peopleLikedArray = [Array<String>]()
    
    var arrFollowers = [String]()
    
    var profilePic = [Dictionary<String, PFFile>]()
    
    var refresher:UIRefreshControl!
    
    func refresh() {
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: activeSec)) as? FeedTableViewCell
        
        self.navigationItem.title = "Discovery"
        
        let profileQuery = PFUser.query()
        
        profileQuery?.findObjectsInBackground(block: { (objects, error) in
            
            if (error != nil) {
                
                print(error)
                
            } else {
                
                if let users = objects {
                    
                    for user in users {
                        
                        self.profilePic.append([user.objectId as! String: user["profilePic"] as! PFFile])
                        
                    }
                    
                }
                
            }
            
        })
        
        let followQuery = PFQuery(className: "Followers")
        
        followQuery.whereKey("followers", equalTo: PFUser.current()?.objectId)
        
        followQuery.findObjectsInBackground { (objects, error) in
            
            if (error != nil) {
                
                let alert = UIAlertController(title: "Unable to obtain data", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
                print(error)
                
            } else {
                
                if let users = objects {
                    
                    for user in users {
                        
                        self.arrFollowers.append(user["following"] as! String)
                        
                    }
                    
                }
                
            }
            
            self.arrFollowers.append((PFUser.current()?.objectId)!)
            
            let newquery = PFQuery(className: "Posts")
            
            newquery.whereKey("userID", containedIn: self.arrFollowers)
            
            newquery.findObjectsInBackground(block: { (objects, error) in
                
                if (error != nil) {
                    
                    print(error)
                    
                } else {
                    
                    if let contents = objects {
                        
                        self.count = contents.count
                        
                        for content in contents {
                            
                            self.objectID.append(content.objectId!)
                            
                            let value = content["tag"] as! Int
                            
                            if (content["peopleLiked"] == nil) {
                                
                                self.peopleLikedArray.append([""])
                                
                            } else {
                                
                                self.peopleLikedArray.append(content["peopleLiked"] as! [String])
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                self.tableView.reloadData()
                
                self.refresher.endRefreshing()
                
            })
            
        }
//
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: UIBarButtonItemStyle.plain, target: self, action: #selector(setting))
//
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refresher.addTarget(self, action: #selector(UserTableViewController.refresh), for: UIControlEvents.valueChanged)
  
        refresh()
        
       tableView.addSubview(refresher)

    }
    
//    func setting() {
//
//        performSegue(withIdentifier: "toSettings", sender: self)
//
//    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return count
        
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
    
    var currentIndex = 0
    
    func heartButtonTapped(_ sender: UITapGestureRecognizer) {
        
        let query = PFQuery(className: "Posts")

        query.whereKey("objectId", equalTo: objectID[self.count - currentIndex - 1])

        query.findObjectsInBackground { (object, error) in
            
            if (error != nil) {
                
                print(error)
                
            } else {
                
                if let posts = object {
                    
                    for post in posts {
                        
                        let peopleLiked = self.peopleLikedArray[self.count - self.currentIndex - 1]
                        
                        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: self.activeSec)) as? FeedTableViewCell
                        
                        if (!peopleLiked.contains(PFUser.current()?.object(forKey: "nickname") as! String)) {
                            
                            let currentLikes = (post["likes"] as! Int) + 1
                            
                            post["likes"] = currentLikes
                            
                            var currentPeopleLiked = (post["peopleLiked"] as? Array<String>)
                            
                            var subArray = currentPeopleLiked
                            
                            if (currentPeopleLiked == nil) {
                                
                                currentPeopleLiked = [PFUser.current()?.object(forKey: "nickname") as! String]
                                
                            } else {
                            
                                currentPeopleLiked?.append(PFUser.current()?.object(forKey: "nickname") as! String)
                                
                                subArray?.insert(PFUser.current()?.object(forKey: "nickname") as! String, at: 0)
                                
                            }
                            
                            post["peopleLiked"] = currentPeopleLiked
                            
                            self.peopleLikedArray[self.count - self.currentIndex - 1] = currentPeopleLiked!
                            
                            var labelString = ""
                                
                            if (currentPeopleLiked!.count <= 3) {
                                
                                cell?.showText.isHidden = true
                                
                                for people in subArray! {
                                    
                                    labelString += people
                                    
                                    labelString += ", "
                                    
                                }
                                
                                if (labelString != "") {
                                
                                    labelString.removeLast()
                                
                                    labelString.removeLast()
                                
                                    labelString += "."
                                    
                                }
                                
                            } else {
                                
                                var counter = 0
                                
                                for people in subArray! {
                                    
                                    if (counter < 3) {
                                        
                                        labelString += people
                                        
                                        labelString += ", "
                                        
                                    }
                                    
                                    counter += 1
                                    
                                }
                                
                                labelString += "etc."
                                
                            }
                            
                            cell?.peopleLiked.text = labelString
                            
                            post["tag"] = 1
                            
                            post.saveInBackground()
                            
                            cell?.cellPeopleLiked = currentPeopleLiked!
                            
                            (sender.view as! UIImageView).image = UIImage(named: "heart.png")
                            
                        } else {
                            
                            let currentLikes = (post["likes"] as! Int) - 1
                            
                            post["likes"] = currentLikes
                            
                            var currentPeopleLiked = (post["peopleLiked"] as? Array<String>)
                            
                            let index = currentPeopleLiked?.index(of: PFUser.current()?.object(forKey: "nickname") as! String)
                            
                            currentPeopleLiked?.remove(at: index!)
                            
                            post["peopleLiked"] = currentPeopleLiked
                            
                            self.peopleLikedArray[self.count - self.currentIndex - 1] = currentPeopleLiked!
                            
                            var labelString = ""
                            
                            if (currentPeopleLiked!.count <= 3) {
                                
                                for people in currentPeopleLiked! {
                                    
                                    labelString += people
                                    
                                    labelString += ", "
                                    
                                }
                                
                                if (labelString != "") {
                                    
                                    labelString.removeLast()
                                    
                                    labelString.removeLast()
                                    
                                    labelString += "."
                                    
                                }
                                
                            } else {
                                
                                var counter = 0
                                
                                for people in currentPeopleLiked! {
                                    
                                    if (counter < 3) {
                                        
                                        labelString += people
                                        
                                        labelString += ", "
                                        
                                    }
                                    
                                    counter += 1
                                    
                                }
                                
                                labelString += "etc."
                                
                            }
                            
                            cell?.cellPeopleLiked = currentPeopleLiked!
                            
                            cell?.peopleLiked.text = labelString
                            
                            post["tag"] = 0
                            
                            post.saveInBackground()
                            
                            cell?.cellPeopleLiked = currentPeopleLiked!
                            
                            (sender.view as! UIImageView).image = UIImage(named: "greyHeart.jpg")
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    var activeSec = 0
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        activeSec = indexPath.section
        
        let cell = tableView.cellForRow(at: indexPath) as! FeedTableViewCell
        
        cell.contentView.backgroundColor = UIColor.white
        
        cell.newLabel.backgroundColor = UIColor.lightGray

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addImageViewWithImage(_:)))

        cell.postedImage.addGestureRecognizer(tapGesture)

        let likeGesture = UITapGestureRecognizer(target: self, action: #selector(heartButtonTapped(_:)))
        
        currentIndex = indexPath.section

        cell.heartIcon.addGestureRecognizer(likeGesture)
     
    }
    
    func removeImage(_ sender: UITapGestureRecognizer) {
        
        let imageView = sender.view as! UIImageView
        imageView.removeFromSuperview()
        
    }
    
    func addImageViewWithImage(_ sender: UITapGestureRecognizer) {
        
        let imageView = UIImageView(frame: self.view.frame)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.black
        imageView.image = (sender.view as! UIImageView).image
        imageView.tag = 100
        imageView.isUserInteractionEnabled = true
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(removeImage))
        imageView.addGestureRecognizer(dismissTap)
        dismissTap.numberOfTapsRequired = 1
        let longHold = UILongPressGestureRecognizer(target: self, action: #selector(saveImage(sender:)))
        imageView.addGestureRecognizer(longHold)
        longHold.minimumPressDuration = 1.5
        imageView.addGestureRecognizer(dismissTap)
        imageView.addGestureRecognizer(longHold)
        UIApplication.shared.windows.first!.addSubview(imageView)
    }
    
    func saveImage(sender: UILongPressGestureRecognizer) {
        
        let image = (sender.view as! UIImageView).image
        
        let alert = UIAlertController(title: "Saving photos to your library", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            UIImageWriteToSavedPhotosAlbum(image!, self, "image:didFinishSavingWithError:contextInfo:", nil)

        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            
        }))
        
        present(alert, animated: true, completion: nil)

    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if (error != nil) {
            // Something wrong happened.
        } else {
            // Everything is alright.
        }
        
    }
    
    
//    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
//
//        let imageView = sender.view as! UIImageView
//        let newImageView = UIImageView(frame: self.view.frame)
//        newImageView.image = imageView.image
//        newImageView.backgroundColor = .black
//        newImageView.contentMode = .scaleAspectFit
//        newImageView.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
//        newImageView.addGestureRecognizer(tap)
//        UIApplication.shared.windows.first!.addSubview(newImageView)
//        self.navigationController?.isNavigationBarHidden = true
//        self.tabBarController?.tabBar.isHidden = true
//    }
//
//    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
//        self.navigationController?.isNavigationBarHidden = false
//        self.tabBarController?.tabBar.isHidden = false
//        sender.view?.removeFromSuperview()
//    }    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        
        self.tableView.rowHeight = 350
        
        let query = PFQuery(className: "Posts")
        
        query.whereKey("userID", containedIn: self.arrFollowers)
        
        query.findObjectsInBackground { (objects, error) in
            
            if (error != nil) {
                
                print(error)
                
            } else {
                
                if let contents = objects {
                    
                    cell.username.text = contents[self.count - indexPath.section - 1]["nickname"] as? String
                    
                    cell.userText.text = contents[self.count - indexPath.section - 1]["message"] as? String

                    let date = contents[self.count - indexPath.section - 1]["createdDate"] as? Date
                    
                    let dateformat = DateFormatter()
                    
                    dateformat.dateStyle = .long
                    
                    let swiftDate = dateformat.string(from: date!)

                    cell.createdDate.text = swiftDate
                    
                    cell.createdDate.textColor = UIColor.darkGray
                    
                    var labelString = ""
                    
                    if (self.peopleLikedArray[self.count - indexPath.section - 1].count <= 3) {
                        
                        cell.showText.isHidden = true
                    
                        for people in self.peopleLikedArray[self.count - indexPath.section - 1] {
                            
                            labelString += people
                            
                            labelString += ", "
                            
                        }
                        
                        if (labelString != "") {
                            
                            labelString.removeLast()
                            
                            labelString.removeLast()
                            
                            labelString += "."
                            
                        }
                       
                    } else {
                        
                        var subArray = self.peopleLikedArray[self.count - indexPath.section - 1]
                        
                        let index = subArray.index(of: PFUser.current()?.object(forKey: "nickname") as! String)
                        
                        if (index != nil) {
                            
                            subArray.remove(at: index!)
                            
                            subArray.insert(PFUser.current()?.object(forKey: "nickname") as! String, at: 0)
                            
                        }
                       
                        var counter = 0
                        
                        for people in subArray {
                            
                            if (counter < 3) {
                            
                                labelString += people
                                
                                labelString += ", "
                                
                            }
                            
                            counter += 1
                            
                        }
                        
                        labelString += "etc."
                        
                    }
                    
                    if (labelString == ".") {
                        
                        labelString = ""
                        
                    }
                    
                    cell.cellPeopleLiked = self.peopleLikedArray[self.count - indexPath.section - 1]
                    
                    cell.peopleLiked.text = labelString
                    
                    cell.peopleLiked.backgroundColor = UIColor.white
                    
                    if (self.peopleLikedArray[self.count - indexPath.section - 1].contains(PFUser.current()?.object(forKey: "nickname") as! String)) {

                        cell.heartIcon.image = UIImage(named: "heart.png")

                    } else {

                        cell.heartIcon.image = UIImage(named: "greyHeart.jpg")

                    }
                    
                    let userID = contents[self.count - indexPath.section - 1]["userID"] as? String
                    
                    for pic in self.profilePic {
                        
                        if (pic.keys.first == userID) {
                        
                            if let data = pic.values.first as? PFFile{
                                
                                data.getDataInBackground(block: { (data, error) in
                                    
                                    if (error != nil) {
                                        
                                        print(error)
                                        
                                    } else {
                                        
                                        let image = UIImage(data: data!)
                                        cell.profileImage.image = image
                                        cell.profileImage.layer.borderWidth = 1
                                        cell.profileImage.layer.masksToBounds = false
                                        cell.profileImage.layer.borderColor = UIColor.white.cgColor
                                        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height / 2
                                        cell.profileImage.clipsToBounds = true
                                        
                                    }
                                    
                                })
                                
                            }

                            
                        }
                        
                    }

                    let file = contents[self.count - indexPath.section - 1]["imageFile"] as! PFFile

                    file.getDataInBackground(block: { (data, error) in
                        
                        if (error != nil) {
                            
                            print(error)
                            
                        } else {
                            
                            cell.postedImage.image = UIImage(data: data!)
                            
                        }
                       
                    })
                        
                }
                    
            }
            
        }
        
        return cell
    }
    
    func showPopOver() {
        
        performSegue(withIdentifier: "popOver", sender: self)
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let query = PFQuery(className: "Posts")
            
            query.whereKey("objectId", equalTo: objectID[self.count - indexPath.section - 1])
            
            query.findObjectsInBackground(block: { (object, error) in
                
                if (error != nil) {
                    
                    print(error)
                    
                } else {
                    
                    if let users = object {
                        
                        for user in users {
                            
                            user.deleteInBackground()
                            
                            self.refresh()
                            
                        }
                        
                    }
                    
                }
                
                tableView.reloadData()
                
            })
            
        }
    }

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





