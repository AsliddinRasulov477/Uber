//
//  BurgerButton.swift
//  Uber
//
//  Created by Asliddin Rasulov on 21/12/20.
//

import UIKit

class BurgerButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.831372549, blue: 0.0431372549, alpha: 1)
        
        layer.masksToBounds = true
        layer.cornerRadius = 30
        
        imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        setImage(#imageLiteral(resourceName: "menu").withTintColor(.systemBackground), for: .normal)
        
        addShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

