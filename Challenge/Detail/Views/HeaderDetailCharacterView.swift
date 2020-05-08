//
//  HeaderDetailView.swift
//  Challenge_Example
//
//  Created by Joao Gabriel Pereira on 07/05/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JewFeatures
import Lottie
import PodAsset

class HeaderDetailCharacterView: UIView {
    
    let imageView = UIImageView(frame: .zero)
    let label = UILabel(frame: .zero)
    var loadingView = AnimationView()
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
        setupLottie()
        setupImage()
        setupLabel()
    }
    
    private func setupImage() {
        if let character = character {
            self.imageView.tintColor = .JEWRed()
            self.imageView.roundAllCorners(borderColor: .clear, cornerRadius: 8)
            self.loadingView.isAnimated(isHidden: false)
            self.imageView.isAnimated(isHidden: true)
            self.loadingView.play()
            self.imageView.downloaded(from: character.thumbnail?.getURLPath() ?? String(), contentMode: .scaleAspectFill) { (image, url) in
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.loadingView.stop()
                    self.loadingView.isAnimated(isHidden: true)
                    self.imageView.isAnimated(isHidden: false)
                }
            }
        }
    }
    
    private func setupLottie() {
        let loadAnimation = Animation.named(LottieConstants.animatedLoading, bundle:  PodAsset.bundle(forPod: JEWConstants.Resources.podsJewFeature.rawValue))
        self.addSubview(loadingView)
        loadingView.backgroundColor = .clear
        loadingView.animation = loadAnimation
        loadingView.contentMode = .scaleAspectFit
        loadingView.animationSpeed = 1
        loadingView.loopMode = .loop
        loadingView.setupConstraints(parent: imageView, centerX: 0, centerY: 0, width: 50, height: 50)
        loadingView.isAnimated(isHidden: true)
    }
    
    func setupLabel() {
        if let character = character {
            self.label.text = character.description
            self.label.numberOfLines = 0
            self.label.textColor = .JEWBlack()
            self.label.font = .JEW20Bold()
            self.label.textAlignment = .center
        }
    }
}
