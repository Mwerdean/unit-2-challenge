//
//  List+Convenience.swift
//  unit 2 challange
//
//  Created by Matthew Werdean on 3/6/20.
//  Copyright © 2020 Matthew Werdean. All rights reserved.
//

import Foundation
import CoreData

extension List {
    @discardableResult
    convenience init(name: String, isComplete: Bool, moc: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: moc)
        self.name = name
        self.isComplete = isComplete
    }
}
