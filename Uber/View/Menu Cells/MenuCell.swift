//
//  MenuCell.swift
//  SideMenuWithTableView
//
//  Created by uchqun on 19/12/20.
//

import Foundation
import UIKit

class MenuCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifire: String = "MenuCell"
    
    private var menuItemImageView : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    private  var menuItemTextView : UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    
    // MARK: - Lifecycle
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(menuItemImageView)
        menuItemImageView.centerY(
            inView: contentView, leftAnchor: contentView.leftAnchor,
            paddingLeft: 8
        )
        menuItemImageView.setDemissions(height: 40, width: 40)
        
        
        contentView.addSubview(menuItemTextView)
        menuItemTextView.anchor(
            top: menuItemImageView.topAnchor, left: menuItemImageView.rightAnchor,
            right: contentView.rightAnchor, paddingLeft: 8, paddingRight: 8, height: 40
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        menuItemImageView.image = nil
        menuItemTextView.text = nil
    }
    
    
    // MARK: - Helper Functions
    
    func configure (menuItemText: String? = nil, image: UIImage? = nil ) {
        menuItemTextView.text = menuItemText
        menuItemImageView.image = image?.withAlignmentRectInsets(
            UIEdgeInsets(top: -5, left: -5, bottom: -5, right: -5)
        )
    }
}
