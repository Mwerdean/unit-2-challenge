//
//  shoppingListTableViewController.swift
//  unit 2 challange
//
//  Created by Matthew Werdean on 3/6/20.
//  Copyright © 2020 Matthew Werdean. All rights reserved.
//

import UIKit
import CoreData

class shoppingListTableViewController: UITableViewController {
        
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        ListController.sharedInstance.fetchedResultsController.delegate = self
    }

    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        // Create the alert
             let alert = UIAlertController(title: "Add item", message: "Please add an item to your shopping list", preferredStyle: .alert)
             
             // Add a text field
             alert.addTextField(configurationHandler: nil)
             
             // Create Cancel button
             let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler:  nil)
             // Create Add button
             let addButton = UIAlertAction(title: "Add", style: .default) {(_) in
                 guard let name = alert.textFields?[0].text, !name.isEmpty else {return}
                ListController.sharedInstance.createList(with: name)
                 // reload data
                 self.tableView.reloadData()
             }
             // Add our buttons to the alert
             alert.addAction(cancelButton)
             alert.addAction(addButton)
             // Present our alert
             self.present(alert, animated: true)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListController.sharedInstance.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? shoppingListTableViewCell else {return UITableViewCell()}
        let list = ListController.sharedInstance.fetchedResultsController.object(at: indexPath)
        cell.updateViews(with: list)
        cell.delegate = self
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let list = ListController.sharedInstance.fetchedResultsController.object(at: indexPath)
            ListController.sharedInstance.deleteList(list: list)
        }
    }
}// End of class

extension shoppingListTableViewController: shoppingListTableViewCellDelegate {
    func toggleImage(for cell: shoppingListTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let list = ListController.sharedInstance.fetchedResultsController.object(at: indexPath)
        ListController.sharedInstance.updateList(list: list)
        cell.updateViews(with: list)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension shoppingListTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    // sets behavior for cells
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .fade)
        case .delete:
            tableView.deleteSections(indexSet, with: .fade)
        default: return
        }
    }
    // additional behavior for cells
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath
                else { return }
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath
                else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath = indexPath
                else { return }
            tableView.reloadRows(at: [indexPath], with: .none)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath
                else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        @unknown default:
            fatalError("NSFetchedResultsChangeType has new unhandled cases")
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

