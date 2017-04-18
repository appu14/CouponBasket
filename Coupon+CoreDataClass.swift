//
//  Coupon+CoreDataClass.swift
//  TrialCouponedIt!! 5
//
//  Created by Apoorva Moodbidri on 3/21/17.
//  Copyright © 2017 Apoorva Moodbidri. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(Coupon)
public class Coupon: NSManagedObject {

    var couponimage:UIImage {
        let image = UIImage(data: self.couponImage! as Data)
        return image!
    }
    var couponname:String!
    var reminderDate:Date!
    var reminderlocationName:String!
}
