//
//  EntityTableViewCell.swift
//  iTunesSearch
//
//  Created by Alagu Karthik Prabhu on 04/02/17.
//  Copyright © 2017 kp Alagu. All rights reserved.
//

import UIKit

class EntityTableViewCell: UITableViewCell {

    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artWork60: UIImageView!
    @IBOutlet weak var shortDescription: UILabel!
    @IBOutlet weak var price: UIPriceLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        trackName.text = "track"
        shortDescription.text = "short"
        price.text = "free"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // MARK: - Configuration
    
    func configureCell(cell: EntityTableViewCell, forEntity entity: iTunesEntityModel) {
        trackName.text = entity.trackName
        shortDescription.text = entity.shortDescription
        price.text = entity.price
    }
    
}
