//
//  OrderCell.swift
//  Uber
//
//  Created by Asliddin Rasulov on 02/12/20.
//

import UIKit

protocol OrderHeaderViewDelegate: AnyObject {
    func presentProfessions()
    func handleYourLocationButton()
}


class OrderHeaderView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: OrderHeaderViewDelegate?
        
    private let order: UIButton = {
        
        let button = UIButton()
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.setTitle("order".localized, for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.831372549, blue: 0.0431372549, alpha: 1)
        
        return button
    }()
    
    let yourLocation: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 30
        button.layer.borderWidth = 2
        button.layer.borderColor = #colorLiteral(red: 0.2549019608, green: 0.831372549, blue: 0.0431372549, alpha: 1)
        button.backgroundColor = .systemBackground
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.setImage(#imageLiteral(resourceName: "target").withTintColor(#colorLiteral(red: 0.2549019608, green: 0.831372549, blue: 0.0431372549, alpha: 1)), for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubviews()
    }
   
    private func addSubviews() {
        addSubview(yourLocation)
        yourLocation.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 16)
        yourLocation.setDemissions(height: 60, width: 60)
        yourLocation.addTarget(self, action: #selector(handleYourLocationButton), for: .touchUpInside)
        
        addSubview(order)
        order.anchor(right: rightAnchor, paddingRight: 16, width: 100, height: 60)
        order.centerY(inView: self)
        order.addTarget(self, action: #selector(presentProfessions), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    @objc func presentProfessions() {
        delegate?.presentProfessions()
    }
    
    @objc func handleYourLocationButton() {
        delegate?.handleYourLocationButton()
    }
}
