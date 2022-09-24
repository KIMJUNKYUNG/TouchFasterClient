//
//  UserCell.swift
//  TouchFaster
//
//  Created by 김준경 on 2022/09/25.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var userNumber: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
