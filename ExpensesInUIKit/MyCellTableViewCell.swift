//
//  MyCellTableViewCell.swift
//  ExpensesInUIKit
//
//  Created by Grifus on 24.04.2021.
//

import UIKit

class MyCellTableViewCell: UITableViewCell {

    @IBOutlet weak var nameTwo: UILabel!
    @IBOutlet weak var nameOne: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
