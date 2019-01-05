//
//  Category.swift
//  Todoey
//
//  Created by George Hadjisavvas on 05/01/2019.
//  Copyright © 2019 George Hadjisavvas. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    //this point to list item object 
    let items = List<Item>()
   
    
}
