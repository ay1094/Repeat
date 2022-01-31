//
//  ContainerView.swift
//  Repeat
//
//  Created by Ahmed Yacoob on 12/26/21.
//

import UIKit

class ContainerButton: UIButton {
    let id: Int
    init(id: Int) {
        self.id = id
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.id = 0
        super.init(coder: aDecoder)
    }
    
    

}
