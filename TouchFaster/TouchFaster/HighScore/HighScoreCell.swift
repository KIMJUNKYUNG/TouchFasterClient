//
//  HighScoreCell.swift
//  TouchFaster
//
//  Created by 김준경 on 2022/10/05.
//

import UIKit

class HighScoreCell: UITableViewCell {
    @IBOutlet weak var order: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
