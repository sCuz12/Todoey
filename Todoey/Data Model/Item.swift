//
//  Item.swift
//  Todoey
//
//  Created by George Hadjisavvas on 05/01/2019.
//  Copyright © 2019 George Hadjisavvas. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    //defining inverse relationships
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
