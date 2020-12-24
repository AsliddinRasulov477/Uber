//
//  WorkerDescriptionCell.swift
//  Uber
//
//  Created by Asliddin Rasulov on 15/12/20.
//

import UIKit

class WorkerDescriptionCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifire = "WorkerDescriptionCell"
    
    private let constAbout: UILabel = {
        let label = UILabel()
        label.text = "About"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let aboutText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = ""
        label.textColor = .label
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
    }
    
    private func addSubviews() {
        
        selectionStyle = .none
        
        contentView.addSubview(constAbout)
        constAbout.anchor(
            top: contentView.topAnchor, left: contentView.leftAnchor,
            paddingTop: 16, paddingLeft: 16
        )
        
        contentView.addSubview(aboutText)
        aboutText.anchor(
            top: constAbout.bottomAnchor, left: constAbout.leftAnchor, right: contentView.rightAnchor,
            paddingTop: 10, paddingRight: 16
        )
        
        contentView.bottomAnchor.constraint(
            equalTo: aboutText.bottomAnchor, constant: 16
        ).isActive = true
    }
    
  
    func configure(with worker: Worker) {
        if worker.description == "" {
            aboutText.text = "No information about the worker!"
        } else {
            aboutText.text = worker.description
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        aboutText.text = nil
    }
    
}

