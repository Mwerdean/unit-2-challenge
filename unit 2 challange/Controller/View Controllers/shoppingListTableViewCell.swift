//
//  shoppingListTableViewCell.swift
//  unit 2 challange
//
//  Created by Matthew Werdean on 3/6/20.
//  Copyright © 2020 Matthew Werdean. All rights reserved.
//

import UIKit

protocol shoppingListTableViewCellDelegate: class {
    func toggleImage(for cell: shoppingListTableViewCell)
}

class shoppingListTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var checkMarkButton: UIButton!
    
    weak var delegate: shoppingListTableViewCellDelegate?
    
    // MARK: - Action
    @IBAction func checkMarkToggled(_ sender: Any) {
        delegate?.toggleImage(for: self)
    }
    
    // MARK: - Helper Methods
    func updateViews(with list: List) {
        cellLabel.text = list.name
        if(list.isComplete) {
            checkMarkButton.setImage(UIImage(named: "complete"), for: .normal)
        } else {
            checkMarkButton.setImage(UIImage(named: "incomplete"), for: .normal)
        }
    }
}
