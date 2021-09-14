//
//  MenuTableViewCell.swift
//  CoreDataPreload
//
//  Created by Adnann Muratovic on 14.09.21.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
        
    
    @IBOutlet weak var detailLabel: UILabel!
        
    
    
    @IBOutlet weak var priceLabel: UILabel!
        
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
