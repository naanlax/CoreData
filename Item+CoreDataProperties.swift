//
//  Item+CoreDataProperties.swift
//  Core_Data_FInal
//
//  Created by Nandhika T M on 02/12/24.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    @NSManaged public var sku: Int64
    @NSManaged public var rate: Int64
    @NSManaged public var image: String?

}

extension Item : Identifiable {

}
