//
//  MyDropDownCell.swift
//  Translator
//
//  Created by tami on 11/19/20.
//

import UIKit
import DropDown

class MyDropDownCell: DropDownCell {

    
    @IBOutlet var myImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
