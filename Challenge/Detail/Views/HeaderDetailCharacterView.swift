//
//  HeaderDetailView.swift
//  Challenge_Example
//
//  Created by Joao Gabriel Pereira on 07/05/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JewFeatures
class HeaderDetailCharacterView: UIView {
    
    let imageView = UIImageView(frame: .zero)
    let label = UILabel(frame: .zero)
    var character: Character?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup(with character: Character?) {
        self.character = character
        setupView()
    }
}

extension HeaderDetailCharacterView: JEWCodeView {
    func buildViewHierarchy() {
        self.addSubview(imageView)
        self.addSubview(label)
        
    }
    
    func setupConstraints() {
        imageView.setupConstraints(parent: self, top: 8, leading: 8, trailing: -8)
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 3/4).isActive = true
        label.setupConstraints(parent: imageView, topBottom: 16)
        label.setupConstraints(parent: self, bottom: 8, leading: 8, trailing: -8)
        layoutIfNeeded()
    }
    
    func setupAdditionalConfiguration() {
        if let character = character {
            self.imageView.downloaded(from: character.thumbnail?.getURLPath() ?? String(), contentMode: .scaleAspectFill) { (image, url) in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
            self.label.text = character.description
        }
        self.imageView.roundAllCorners(borderColor: .clear, cornerRadius: 8)
        self.label.numberOfLines = 0
        self.label.textColor = .JEWBlack()
        self.label.font = .JEW20Bold()
        self.label.textAlignment = .center
    }
    
    
    
}
