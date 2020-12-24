//
//  WorkersCell.swift
//  Uber
//
//  Created by Asliddin Rasulov on 28/11/20.
//

import UIKit
import SDWebImage

protocol WorkerMainCellDelegate: AnyObject {
    func handleCallNowButton()
}

class WorkerMainCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifire = "WorkerMainCell"
    
    private let profilePhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let callNowButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 30
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.setImage(#imageLiteral(resourceName: "callnow").withTintColor(.systemBackground), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.831372549, blue: 0.0431372549, alpha: 1)
        return button
    }()
    
    weak var delegate: WorkerMainCellDelegate?
    
    
    
    // MARK: - Lifecycle
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        fullnameLabel.text = nil
        profilePhoto.image = nil
    }
    
    
    // MARK: - Helper Functions
    
    private func addSubviews() {
        
        selectionStyle = .none
        
        contentView.addSubview(profilePhoto)
        profilePhoto.anchor(
            top: contentView.topAnchor, left: contentView.leftAnchor,
            paddingTop: 5, paddingLeft: 5, width: 80, height: 80
        )
        
        contentView.addSubview(fullnameLabel)
        fullnameLabel.anchor(
            top: profilePhoto.topAnchor, left: profilePhoto.rightAnchor, paddingLeft: 15
        )
        
        contentView.addSubview(phoneLabel)
        phoneLabel.centerY(
            inView: profilePhoto, leftAnchor: fullnameLabel.leftAnchor
        )
        
        contentView.addSubview(distanceLabel)
        distanceLabel.anchor(
            left: fullnameLabel.leftAnchor, bottom: profilePhoto.bottomAnchor
        )
        
        contentView.addSubview(callNowButton)
        callNowButton.addTarget(
            self, action: #selector(handleCallNowButton), for: .touchUpInside
        )
        callNowButton.anchor(
            bottom: profilePhoto.bottomAnchor, right: contentView.rightAnchor,
            paddingRight: 10, width: 60, height: 60
        )
        
        contentView.bottomAnchor.constraint(
            equalTo: profilePhoto.bottomAnchor, constant: 5
        ).isActive = true
    }
    
  
    func configure(with worker: Worker) {
        if let imageURL = getURLFromString("http://167.99.33.2/" + worker.avatar) {
            if worker.avatar == "" {
                profilePhoto.image = #imageLiteral(resourceName: "fullname").withTintColor(.label).withAlignmentRectInsets(
                    UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
                )
            } else {
                profilePhoto.sd_imageIndicator = SDWebImageActivityIndicator.gray
                profilePhoto.sd_setImage(with: imageURL)
            }
        }
        fullnameLabel.text = worker.firstName + " " + worker.lastName
        phoneLabel.text = worker.phone
        distanceLabel.text = String(format: "%.02f", worker.distance / 1000) + " km"
    }
    
    private func getURLFromString(_ str: String) -> URL? {
        return URL(string: str)
    }
    
    // MARK: - Selectors
    
    @objc func handleCallNowButton() {
        delegate?.handleCallNowButton()
    }
}
