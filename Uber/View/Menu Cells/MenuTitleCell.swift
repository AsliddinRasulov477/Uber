//
//  MenuCell.swift
//  SideMenuWithTableView
//
//  Created by uchqun on 19/12/20.
//

import Foundation
import UIKit

class MenuTitleCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifire: String = "MenuTitleCell"
    
    private let menuItemImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let menuUserLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let menuPhoneLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(menuItemImageView)
        menuItemImageView.centerX(inView: contentView)
        menuItemImageView.anchor(
            top: contentView.topAnchor, paddingTop: 30,
            width: 60, height: 60
        )
        
        contentView.addSubview(menuUserLabel)
        menuUserLabel.centerX(inView: contentView)
        menuUserLabel.anchor(
            top: menuItemImageView.bottomAnchor, paddingTop: 5,
            width: contentView.frame.width * 0.6, height: 25
        )
        
        contentView.addSubview(menuPhoneLabel)
        menuPhoneLabel.centerX(inView: contentView)
        menuPhoneLabel.anchor(
            top: menuUserLabel.bottomAnchor, paddingTop: 5,
            width: contentView.frame.width, height: 25
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        menuUserLabel.text = nil
        menuPhoneLabel.text = nil
        menuItemImageView.image = nil
    }

    // MARK: - Helper Functions
    
    func configure (menuItemText: String, menuPhoneText: String, image: UIImage) {
        menuUserLabel.text = menuItemText
        menuPhoneLabel.text = menuPhoneText
        menuItemImageView.image = image
    }

    
}
