//
//  utils.swift
//  TouchFaster
//
//  Created by 김준경 on 2022/09/24.
//

import UIKit

extension NSArray{
    func getNSDict(_ index : Int) -> NSDictionary?{
        return self.object(at: index) as? NSDictionary
    }
}
