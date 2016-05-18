//
//  CustomeCell.swift
//  GoogleMapsAPI-4900
//
//  Created by Ricky Chen on 5/3/16.
//  Copyright © 2016 Jan Ycasas. All rights reserved.
//

import UIKit

class CustomeCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var availiability: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
