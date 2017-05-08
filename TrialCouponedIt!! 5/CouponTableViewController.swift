//
//  CouponTableViewController.swift
//  TrialCouponedIt!! 5
//
//  Created by Apoorva Moodbidri on 3/16/17.
//  Copyright © 2017 Apoorva Moodbidri. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications




class CouponTableViewController: UITableViewController,SaveCoupon,UISearchResultsUpdating,UISearchBarDelegate{
    //MARK: properties
    var coupons:[Coupon] = []
    let searchController = UISearchController(searchResultsController: nil)
    var shouldShowSearchResults = false
    var filteredResult = [Coupon]()

   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search Coupons With The Coupon Name "
        searchController.searchBar.delegate = self
       
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        tableView.contentOffset = CGPoint(x: 0.0, y: 44.0)
        loadData()
        
        
//          self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//          self.navigationController?.navigationBar.shadowImage = UIImage()
          self.navigationController?.navigationBar.backgroundColor = UIColor.clear
          //UINavigationBar.appearance().backgroundColor = UIColor.clear
          self.navigationController?.navigationBar.isTranslucent = true
          view.isOpaque = false
        
        
        view.addGradientWithColor(color: UIColor(red:0.33, green:0.59, blue:0.69, alpha:1.0))
        
    }
    
   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredResult.count
        } else  {
            return coupons.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CouponTableViewCell
        
        if searchController.isActive && searchController.searchBar.text != "" {
            print(filteredResult)
            let index = filteredResult[(indexPath as NSIndexPath).row]
            cell.couponNameLabel.text = index.couponName
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let dateString = dateFormatter.string(from: index.expiryDate! as Date)
            cell.expiryDateLabel.text = dateString
            
            cell.couponImageView.image = index.couponimage
            cell.locationNameLabel.text = index.reminderLocationName
          
            func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
                
                searchBar.text = nil
                
                searchBar.showsCancelButton = false
                searchBar.endEditing(true)
                
                let index = coupons[(indexPath as NSIndexPath).row]
                cell.couponNameLabel.text  = index.couponName
                cell.couponImageView.image = index.couponimage
                
            }

        
        }
        else {
        
        // Configure the cell...
        let index = coupons[(indexPath as NSIndexPath).row]
        cell.couponNameLabel.text = index.couponName
        
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        
//        let dateString = dateFormatter.string(from: index.expiryDate! as Date)
//        cell.expiryDateLabel.text = dateString
        
             cell.couponImageView.image = index.couponimage
        
            //cell.locationNameLabel.text = index.reminderLocationName
    
         
        }
       
          cell.couponImageView.layer.frame = cell.couponImageView.layer.frame.insetBy(dx: 0, dy: 0)

          cell.couponImageView.layer.cornerRadius = 15
          cell.couponImageView.layer.masksToBounds = false
          cell.couponImageView.clipsToBounds = true
//        cell.couponImageView.contentMode = UIViewContentMode.scaleAspectFill
          cell.backgroundColor = UIColor.clear
          cell.couponNameLabel.text  = cell.couponNameLabel.text?.uppercased()

        return cell
    }
    
   
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    
    //MARK: Search Functions 
    /*
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableView.reloadData()
    }
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        if !shouldShowSearchResults {
//            shouldShowSearchResults = true
//            tableView.reloadData()
//        }
//            searchController.searchBar.resignFirstResponder()
//    }
   */
    
    func filterContentForSearcText(searchText:String , scope: String = "All")
    {
        filteredResult = coupons.filter({ (coupon) -> Bool in
            return (coupon.couponName?.lowercased().contains(searchText.lowercased()))!
    
        })
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
     filterContentForSearcText(searchText: searchController.searchBar.text!)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = getContext()
        if editingStyle == .delete {
            // Delete the row from the data source
            context.delete(coupons[(indexPath as NSIndexPath).row])
            
            let index = (coupons[(indexPath as NSIndexPath).row])
            let center = UNUserNotificationCenter.current()
            let notificationToDelete = index.couponName
            let locationNotificationToDelete = index.reminderLocationName
            
            center.removeAllDeliveredNotifications()
            center.removePendingNotificationRequests(withIdentifiers: [notificationToDelete!])
            center.removePendingNotificationRequests(withIdentifiers: [locationNotificationToDelete!])

            
            do {
                try context.save()
            } catch let error as NSError {
                print("Failed: \(error.userInfo)")
            }
            coupons.remove(at: (indexPath as NSIndexPath).row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            tableView.reloadData()
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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
    
    //MARK: CoreData & protocol Adaption
    func getContext()->NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func saveCoupon(image: UIImage, name: String, date: Date, locationName: String) {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Coupon", in: context)
        let coupon = Coupon(entity: entity!, insertInto: context)
        coupon.couponName = name
        coupon.expiryDate = date as NSDate?
        coupon.couponImage = UIImageJPEGRepresentation(image, 1) as NSData?
        coupon.reminderLocationName = locationName
        coupons.append(coupon)
        do {
            try context.save()
        } catch let error as NSError {
            print("Failed : \(error.userInfo)")
        }
        tableView.reloadData()
    }

    
    func loadData() {
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Coupon")
        do {
            let result = try context.fetch(fetchRequest)
            coupons = result as! [Coupon]
        } catch let error as NSError {
            print("Failed: \(error.userInfo) ")
        }
        tableView.reloadData()
    }
    
    
    
   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "AddCouponSegue" {
               let destinationViewController = segue.destination as! AddCouponViewController
        // Pass the selected object to the new view controller.
               destinationViewController.delegate = self
               if let indexPath = tableView.indexPathForSelectedRow {
            destinationViewController.couponName = coupons[indexPath.row].couponName
            destinationViewController.couponIMage.image = coupons[indexPath.row].couponimage
            destinationViewController.locationNameToNotify = coupons[indexPath.row].reminderLocationName
          }
        } else
            if segue.identifier == "ShowCouponSegue" {
                let destVC = segue.destination as! DetailViewController
                if searchController.isActive && searchController.searchBar.text != "" {
                    if let indexpath = tableView.indexPathForSelectedRow {
                        destVC.cName = filteredResult[indexpath.row].couponName
                        destVC.location  = filteredResult[indexpath.row].reminderLocationName
                        destVC.cimage = filteredResult[indexpath.row].couponimage
                        let index = filteredResult[indexpath.row]
                        let dateformatter = DateFormatter()
                        dateformatter.dateFormat = "yyyy-MM-dd"
                        let datestring = dateformatter.string(from: index.expiryDate! as Date)
                        destVC.dateString = datestring
                    }
                } else {
                    if let indexpath = tableView.indexPathForSelectedRow {
                    destVC.cName = coupons[indexpath.row].couponName
                    destVC.location  = coupons[indexpath.row].reminderLocationName
                    destVC.cimage = coupons[indexpath.row].couponimage
                    let index = coupons[indexpath.row]
                    let dateformatter = DateFormatter()
                    dateformatter.dateFormat = "yyyy-MM-dd"
                    let datestring = dateformatter.string(from: index.expiryDate! as Date)
                    destVC.dateString = datestring
                }
            }
        }
    }

}
