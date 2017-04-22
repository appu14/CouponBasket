//
//  RemindDateViewController.swift
//  TrialCouponedIt!! 5
//
//  Created by Apoorva Moodbidri on 3/21/17.
//  Copyright © 2017 Apoorva Moodbidri. All rights reserved.
//

import UIKit
import  UserNotifications

protocol SaveCouponName
{
    func saveCoupon(name:String,date:Date)
}

class RemindDateViewController: UIViewController,UNUserNotificationCenterDelegate,UITextFieldDelegate{

    //MARK: Properties
    
    @IBOutlet weak var couponNameTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var messageTextField: UITextField!
   
    var delegate:SaveCouponName? = nil
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      UNUserNotificationCenter.current().delegate = self
     
       
    }

    func scheduleNotification(at date:Date) {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current,  year: components.year, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Notification"
        content.body = messageTextField.text!
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: couponNameTextField.text!, content: content, trigger: trigger)
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().add(request) { (error) in
            if(error != nil) {
                print("Failed \(error.debugDescription)")
            }
        }
        
    }
    
    func takeaction() {
        //1.create action and category for your reminder notification
        //2. Addd it to the UNUserNotificationCenter
        let action = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        
        let category = UNNotificationCategory(identifier: "Notify", actions: [action], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "Snooze" {
            let newDate = Date(timeInterval: 900, since: Date())
            scheduleNotification(at: newDate)
        }
    }

    //MARK: Actions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        scheduleNotification(at: datePicker.date)
        delegate?.saveCoupon(name: couponNameTextField.text!, date: datePicker.date)
        _ = navigationController?.popViewController(animated: true)
        
        
    }
    

    @IBAction func cancelButtonTapped(_ sender: Any) {
        
       _ = navigationController?.popViewController(animated: true)
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
