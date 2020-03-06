//
//  ListController.swift
//  unit 2 challange
//
//  Created by Matthew Werdean on 3/6/20.
//  Copyright © 2020 Matthew Werdean. All rights reserved.
//

import Foundation
import CoreData

class ListController {
    // MARK: - Singleton
    static let sharedInstance = ListController()
    var fetchedResultsController: NSFetchedResultsController<List>
    
    init() {
        let request: NSFetchRequest<List> = List.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let resultsController: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController = resultsController
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("There was an error somewhere in your project and youre not gonna know how to handle it because I didn't tell you what it was.")
        }
    }
    
    // MARK: - CRUD
    func createList(with name: String) {
        List(name: name, isComplete: false)
        saveToPersistentStore()
    }
    
    func deleteList(list: List) {
        CoreDataStack.context.delete(list)
        saveToPersistentStore()
    }
    
    func updateList(list: List) {
        list.isComplete = !list.isComplete
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("There was an error saving the data \(#function) \(error.localizedDescription)")
        }
    }
}
