//
//  DetailViewController.swift
//  TrialCouponedIt!! 5
//
//  Created by Apoorva Moodbidri on 4/4/17.
//  Copyright © 2017 Apoorva Moodbidri. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UIScrollViewDelegate{

    //Properties 
    
    @IBOutlet weak var scrollView: UIScrollView!
    
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

        couponNameLabel.layer.masksToBounds = true
        
        expiryDateLabel.layer.cornerRadius = 07
        expiryDateLabel.layer.borderWidth = 0

        
        locationNameLabel.layer.cornerRadius = 12
        locationNameLabel.layer.borderWidth = 0

        let borderWidth:CGFloat = 1.0
        let borderColor:UIColor = UIColor.lightGray
        expiryDateLabel.addRightBorderWithColor(color: borderColor, width: borderWidth)
    
        // self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
      //  self.navigationController?.navigationBar.shadowImage = UIImage()
        
      //  self.navigationController?.view.backgroundColor = UIColor.clear
      //  self.navigationController?.navigationBar.isTranslucent = true
        view.isOpaque = false
        
        //scrollview
      
        scrollView.backgroundColor = UIColor.black
        self.scrollView.contentSize = view.frame.size
        
        
        self.scrollView.addSubview(couponImageView)
        
        self.scrollView.delegate = self
        
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 0.1
        
        
        
       
//         scrollView.contentOffset = CGPoint(x: 1000, y: 450)

    }
    
    //scrollview delegate 
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews.first
        // returns a view that will be scaled. if delegate returns nil, nothing happens
    }
    
//    func setZoomScale()
//    {
//        let imageViewSize = couponImageView.bounds.size
//        let scrollViewSize = scrollView.bounds.size
//        let widthScale = scrollViewSize.width / imageViewSize.width
//        let heightScale = scrollViewSize.height / imageViewSize.height
//        scrollView.minimumZoomScale = min(widthScale, heightScale)
//        scrollView.zoomScale = 1.0
//        
//    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        //basically to place the image back to center after zooming
        let imageViewSize = couponImageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2:0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2:0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
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

