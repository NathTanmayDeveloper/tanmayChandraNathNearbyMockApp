//
//  LocationTableViewCell.swift
//  tanmayChandraNathNearbyMockApp
//
//  Created by Tanmay Chandra Nath on 11/05/24.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    func configure(header: String?, bottom: String?) {
        headerLabel.text = header
        bottomLabel.text = bottom
    }
}
