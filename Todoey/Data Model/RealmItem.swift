//
//  RealmItem.swift
//  Todoey
//
//  Created by Andrew Nyago on 27/10/2018.
//  Copyright © 2018 janus. All rights reserved.
//

import Foundation
import RealmSwift

class RealmItem: Object {
    @objc dynamic var title = ""
    @objc dynamic var done = false
    
    var parentCategory = LinkingObjects(fromType: RealmCategory.self, property: "items")
}
