//
//  AddMemberCell.swift
//  scheduler-app
//
//  Created by Victoria on 3/7/16.
//  Copyright © 2016 Victoria. All rights reserved.
//

import UIKit

class AddMemberCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var removeBtn: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        name.text="Torie"
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
