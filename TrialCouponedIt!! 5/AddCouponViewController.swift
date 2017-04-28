//
//  AddCouponViewController.swift
//  TrialCouponedIt!! 5
//
//  Created by Apoorva Moodbidri on 3/16/17.
//  Copyright © 2017 Apoorva Moodbidri. All rights reserved.
//

import UIKit
protocol SaveCoupon {
    func saveCoupon(image:UIImage, name:String, date:Date, locationName:String)
}

class AddCouponViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SaveCouponName,SaveLocation{
    //MARK: Properties

    @IBOutlet weak var couponIMage: UIImageView!
    
    @IBOutlet weak var expiryDateReminderButton: UIButton!
    
    @IBOutlet weak var locationNotifierButton: UIButton!
    
    @IBOutlet weak var couponNameLabel: UILabel!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let imagePicker = UIImagePickerController()
    var selectedImage:UIImage? = nil
    var couponName:String? = nil
    var expiryDate:Date? = nil
    var delegate:SaveCoupon? = nil
    var locationNameToNotify:String? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //create tapgesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
    // add it to the imageView
        couponIMage.addGestureRecognizer(tapGesture)
    //enable user interaction for the imageView
        couponIMage.isUserInteractionEnabled = true
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.isTranslucent = true
        view.isOpaque = false
//        self.view.backgroundColor = UIColor(red:0.27, green:0.53, blue:0.64, alpha:1.0)
        //view.backgroundColor = UIColor.lightGray.withAlphaComponent(75)
        //expiryDateReminderButton.backgroundColor = UIColor(red:0.17, green:0.52, blue:0.55, alpha:1.0)
        //expiryDateReminderButton.layer.cornerRadius = 12
//        expiryDateReminderButton.layer.borderWidth = 0.5
     
        let borderWidth:CGFloat = 1.0
        let borderColor:UIColor = UIColor.lightGray
        expiryDateReminderButton.addRightBorderWithColor(color: borderColor, width: borderWidth)
        
        //locationNotifierButton.backgroundColor = UIColor(red:0.17, green:0.52, blue:0.55, alpha:1.0)
       // locationNotifierButton.layer.cornerRadius = 12
       // locationNotifierButton.layer.borderWidth = 0
        //couponNameLabel.backgroundColor = UIColor(red:0.17, green:0.52, blue:0.55, alpha:1.0)
       // couponNameLabel.layer.masksToBounds = true
       // couponNameLabel.layer.cornerRadius = 12
       // couponNameLabel.layer.borderWidth = 0
        saveButton.isEnabled = false
        
        
        
    }

    func imageTapped () {
        //create popup menu for camera or photoLibrary 
        let optionsMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionsMenu.popoverPresentationController?.sourceView = self.view
        
        //create actions to add to the options menu 
        let clickPhoto = UIAlertAction(title: "Camera", style: .default) {
            (UIAlertaction) in
            self.clickPhoto()
        }
       let openPhotoLibrary = UIAlertAction(title: "PhotoLibrary", style: .default) { (UIAlertAction) in
        self.openPhotoLibrary()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) {
            (UIAlertAction) in
            print("Selection Has Been Cancelled ")
        }
        
        imagePicker.delegate = self
        
        //add actions to optionsMenu
        optionsMenu.addAction(clickPhoto)
        optionsMenu.addAction(openPhotoLibrary)
        optionsMenu.addAction(cancel)
        self.present(optionsMenu, animated: true, completion: nil)
    }
    
    
    func clickPhoto() {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.cameraFlashMode = .auto
            imagePicker.allowsEditing = false
            imagePicker.modalPresentationStyle = .fullScreen
            let mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)
            if mediaTypes?.contains("public.image") == true {
                //checking still image type[mediaTypes] for source camera
                imagePicker.mediaTypes = ["public.image"]
                self.present(imagePicker, animated: true, completion: nil)
            }
        } else {
            noCamera()
        }
    }
    
    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            imagePicker.modalPresentationStyle = .popover
            imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func noCamera() {
        let alertView = UIAlertController(title: "NO Camera", message: "There is no camera on this device", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertView.addAction(okAction)
        present(alertView, animated: true, completion: nil)

    }
    
    //action to be taken once the photo is selected
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image = UIImage()
        image = info[UIImagePickerControllerOriginalImage]  as! UIImage //specifies the original image selected by the user
        couponIMage.image = image
        self.dismiss(animated: true, completion: nil)
        let imageData:Data? = UIImageJPEGRepresentation(image, 1)//Returns the data for the specified image in JPEG format.
        selectedImage = UIImage(data: imageData!)//Initializes and returns the image object with the specified data.
        UIImageWriteToSavedPhotosAlbum(selectedImage!, nil, nil, nil)//saves the user selected photo the photoLibrary
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
   //Protocol Adaption
    func saveCoupon(name: String, date: Date) {
        print("please ya \(name) \(date)")
        couponName = name
        expiryDate = date
        couponNameLabel.text = name
    saveButton.isEnabled = true
    
    }
    
    func saveLocation(locationName: String) {
        locationNameToNotify = locationName
    }
   
    //MARK: Actions

    @IBAction func saveButtonTapped(_ sender: Any) {
        delegate?.saveCoupon(image: couponIMage.image!, name: couponName!, date: expiryDate!, locationName: locationNameToNotify!)
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "DateSegue"{
        let destinationViewController = segue.destination as! RemindDateViewController
        // Pass the selected object to the new view controller.
        destinationViewController.delegate = self
        }
        else
            if segue.identifier == "MapSegue" {
                let destinationViewController = segue.destination as! GeotificationViewController
                destinationViewController.delegate = self
        }
        
    }
    

}
extension UIView{
    func addRightBorderWithColor(color:UIColor,width:CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
}
