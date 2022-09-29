//
//  GameProfile.swift
//  TouchFaster
//
//  Created by 김준경 on 2022/09/27.
//

import UIKit

class GameProfile : UIView{
    
    @IBOutlet var contentview: UIView!
    
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var ready: UILabel!
    
    override init(frame: CGRect) {
    super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        Bundle.main.loadNibNamed("GameProfile", owner: self)
        
        self.addSubview(contentview)
        contentview.frame = self.bounds
        contentview.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.contentview.layer.cornerRadius = self.contentview.bounds.height / 6
        contentview.layer.borderWidth = 1
        contentview.layer.borderColor = UIColor.systemGray6.cgColor
    }
}
