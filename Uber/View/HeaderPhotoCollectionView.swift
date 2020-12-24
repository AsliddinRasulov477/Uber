//
//  HeaderPhotoCollection.swift
//  Uber
//
//  Created by Asliddin Rasulov on 21/12/20.
//

import UIKit

protocol HeaderPhotoCollectionViewDelegate: AnyObject {
    func handleShare()
}


class HeaderPhotoCollectionView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: HeaderPhotoCollectionViewDelegate?
        
    private let sharePhoto: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.imageEdgeInsets = UIEdgeInsets(
            top: 5, left: 5, bottom: 5, right: 5
        )
        button.setImage(#imageLiteral(resourceName: "share").withTintColor(#colorLiteral(red: 0.2549019608, green: 0.831372549, blue: 0.0431372549, alpha: 1)), for: .normal)
        return button
    }()
    
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubviews()
    }
   
    private func addSubviews() {
        addSubview(sharePhoto)
        sharePhoto.anchor(right: rightAnchor, paddingRight: 8, width: 40, height: 40)
        sharePhoto.centerY(inView: self)
        sharePhoto.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    @objc func handleShare() {
        delegate?.handleShare()
    }
}

