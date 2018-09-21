//
//  Data.swift
//  Todoey
//
//  Created by Kuan-Sheng Hsieh on 2018-09-20.
//  Copyright © 2018 Kuan-Sheng Hsieh. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var createdDate:Date? = nil
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
