//
//  DetailViewController.swift
//  TrialCouponedIt!! 5
//
//  Created by Apoorva Moodbidri on 4/4/17.
//  Copyright © 2017 Apoorva Moodbidri. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    //Properties 
    
    
    @IBOutlet weak var couponNameLabel: UILabel!
    var cName:String? = nil
    
    @IBOutlet weak var couponImageView: UIImageView!
    var cimage:UIImage? = nil
    
    @IBOutlet weak var expiryDateLabel: UILabel!
    var dateString:String? = nil 
    
    @IBOutlet weak var locationNameLabel: UILabel!
    var location:String? = nil
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        couponImageView.image = cimage 
        couponNameLabel.text = cName
        expiryDateLabel.text = dateString
        locationNameLabel.text = location
        
        
        couponNameLabel.layer.cornerRadius = 07
        couponNameLabel.layer.borderWidth = 0
       // couponNameLabel.backgroundColor = UIColor(red:0.17, green:0.52, blue:0.55, alpha:1.0)
        couponNameLabel.layer.masksToBounds = true
        
        expiryDateLabel.layer.cornerRadius = 07
        expiryDateLabel.layer.borderWidth = 0
        //expiryDateLabel.backgroundColor = UIColor(red:0.17, green:0.52, blue:0.55, alpha:1.0)
//        expiryDateLabel.layer.masksToBounds = true
        
        locationNameLabel.layer.cornerRadius = 12
        locationNameLabel.layer.borderWidth = 0
       // locationNameLabel.backgroundColor = UIColor(red:0.17, green:0.52, blue:0.55, alpha:1.0)
//        locationNameLabel.layer.masksToBounds = true
        let borderWidth:CGFloat = 1.0
        let borderColor:UIColor = UIColor.lightGray
        expiryDateLabel.addRightBorderWithColor(color: borderColor, width: borderWidth)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.isTranslucent = true
        view.isOpaque = false
//        self.view.backgroundColor = UIColor(red:0.04, green:0.18, blue:0.34, alpha:1.0)
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
         if segue.identifier == "ShowCouponSegue"
     {
        let destinationViewController = segue.destination as! CouponTableViewController
         // Pass the selected object to the new view controller.
      
     
     }
    */

}

