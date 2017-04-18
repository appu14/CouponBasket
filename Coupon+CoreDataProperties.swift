//
//  Coupon+CoreDataProperties.swift
//  TrialCouponedIt!! 5
//
//  Created by Apoorva Moodbidri on 3/21/17.
//  Copyright © 2017 Apoorva Moodbidri. All rights reserved.
//

import Foundation
import CoreData


extension Coupon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Coupon> {
        return NSFetchRequest<Coupon>(entityName: "Coupon");
    }

    @NSManaged public var couponImage: NSData?
    @NSManaged public var couponName: String?
    @NSManaged public var expiryDate: NSDate?
    @NSManaged public var reminderLocationName: String?

}
