//
//  Data.swift
//  Todoey
//
//  Created by Andrew Nyago on 27/10/2018.
//  Copyright © 2018 janus. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = "" //tell the runtime to use dynamic dispatch over the standard whch is a static dispatch, so, the property will be monitored for change while the app is running.
    @objc dynamic var age: Int = 0
}
