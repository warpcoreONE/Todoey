//
//  Category.swift
//  Todoey
//
//  Created by Kuan-Sheng Hsieh on 2018-09-20.
//  Copyright © 2018 Kuan-Sheng Hsieh. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name:String = ""
    @objc dynamic var backgroundColor:String = ""
    let items = List<Item>()
}


