//
//  SampleTableViewCell.swift
//  iFireBase
//
//  Created by Rahul on 19/11/18.
//  Copyright © 2018 arka. All rights reserved.
//

import UIKit

class SampleTableViewCell: UITableViewCell {
    @IBOutlet weak var label1: UILabel!
     @IBOutlet weak var label2: UILabel!
     @IBOutlet weak var label3: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
