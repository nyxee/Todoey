//
//  RealmCategory.swift
//  Todoey
//
//  Created by Andrew Nyago on 27/10/2018.
//  Copyright © 2018 janus. All rights reserved.
//

import Foundation
import RealmSwift

class RealmCategory: Object {
    @objc dynamic var name = ""
    
    let items = List<RealmItem>()
    
}
