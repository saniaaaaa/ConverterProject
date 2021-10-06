//
//  CurrencyTableViewCell.swift
//  converterApp
//
//  Created by iglo on 06/10/21.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var abbreviationLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        currencyLabel.text = ""
        abbreviationLabel.text = ""
        amountLabel.text = ""
    }
    
}
