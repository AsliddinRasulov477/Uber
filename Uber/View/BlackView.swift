//
//  BlackView.swift
//  Uber
//
//  Created by Asliddin Rasulov on 14/12/20.
//

import UIKit

class BlackView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.831372549, blue: 0.0431372549, alpha: 1)
        layer.masksToBounds = true
        layer.cornerRadius = 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
