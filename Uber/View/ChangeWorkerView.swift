//
//  GoHomeHeaderView.swift
//  Uber
//
//  Created by Asliddin Rasulov on 09/12/20.
//

import UIKit

protocol ChangeWorkerViewDelegate: AnyObject {
    func changeWorker(with tag: Int)
}


class ChangeWorkerView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: ChangeWorkerViewDelegate?
         
    let nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tag = 1
        button.setTitle("next ⟩", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.2549019608, green: 0.831372549, blue: 0.0431372549, alpha: 1), for: .normal)
        return button
    }()
    
    let previousButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tag = -1
        button.setTitle("⟨ previous", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.2549019608, green: 0.831372549, blue: 0.0431372549, alpha: 1), for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = true
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMinYCorner,
                                         .layerMaxXMinYCorner]
        
        backgroundColor = .systemBackground
        
        addSubviews()
    }
   
    private func addSubviews() {
        
        let blackView = BlackView()
        self.addSubview(blackView)
        blackView.centerX(inView: self)
        blackView.anchor(
            top: topAnchor, paddingTop: 5, width: 50, height: 5
        )
        
        addSubview(nextButton)
        nextButton.anchor(
            top: topAnchor, bottom: bottomAnchor, right: rightAnchor,
            paddingRight: 5, width: 100
        )
        nextButton.addTarget(
            self, action: #selector(handleChangeWorker(_ :)),
            for: .touchUpInside
        )
        
        addSubview(previousButton)
        previousButton.anchor(
            top: topAnchor, left: leftAnchor, bottom: bottomAnchor,
            paddingLeft: 5, width: 100
        )
        previousButton.addTarget(
            self, action: #selector(handleChangeWorker(_ :)),
            for: .touchUpInside
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    @objc func handleChangeWorker(_ sender: UIButton) {
        delegate?.changeWorker(with: sender.tag)
    }
}
