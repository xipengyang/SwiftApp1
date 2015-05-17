//
//  OrderProductCell.swift
//  we sale assistant
//
//  Created by xipeng yang on 22/02/15.
//  Copyright (c) 2015 xipeng yang. All rights reserved.
//

import UIKit

class OrderProductCell: UITableViewCell {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var leftImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
