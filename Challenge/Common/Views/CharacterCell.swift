//
//  CharacterCell.swift
//  Challenge_Example
//
//  Created by Joao Gabriel Pereira on 06/05/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JewFeatures
import Lottie
import PodAsset

class CharacterCell: UICollectionViewCell {
    
    @IBOutlet weak var roundedContentView: UIView!
    @IBOutlet weak var contentImageView: UIView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterImage: UIImageView!
    var loadingView = AnimationView()
    private(set) var characterID: Int = 0
    public var onFavorite: ((Int, Bool, UIImage?) -> Void)?

    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        roundedContentView.round(radius: 8, backgroundColor: .white, borderColor: .JEWPallete(red: 230, green: 230, blue: 230), borderWidth: 1, withShadow: true)
    }
    
    
    public func setup(_ viewModel: CharacterViewModel) {
        layoutIfNeeded()
        setupLottie()
        setupLabel(viewModel)
        characterID = viewModel.id
        self.characterImage.tintColor = .JEWDefault()
        favoriteButton.isSelected = viewModel.isFavorite
        setupButtonColor()
        setupImage(viewModel)
    }
    
    private func setupLabel(_ viewModel: CharacterViewModel) {
        characterNameLabel.text = viewModel.name
        characterNameLabel.textColor = .JEWBlack()
        characterNameLabel.font = .JEW13Bold()
    }
    
    private func setupLottie() {
        let loadAnimation = Animation.named(LottieConstants.animatedLoading, bundle:  PodAsset.bundle(forPod: JEWConstants.Resources.podsJewFeature.rawValue))
        contentImageView.addSubview(loadingView)
        loadingView.backgroundColor = .clear
        loadingView.animation = loadAnimation
        loadingView.contentMode = .scaleAspectFit
        loadingView.animationSpeed = 1
        loadingView.loopMode = .loop
        loadingView.setupConstraints(parent: characterImage, centerX: 0, centerY: 0, width: 50, height: 50)
        loadingView.isAnimated(isHidden: true)
    }
    
    private func setupImage(_ viewModel: CharacterViewModel) {
        self.loadingView.isAnimated(isHidden: false)
        self.characterImage.isAnimated(isHidden: true)
        self.loadingView.play()
        if let image = viewModel.image {
            self.characterImage.image = image
            self.loadingView.stop()
            self.loadingView.isAnimated(isHidden: true)
            self.characterImage.isAnimated(isHidden: false)
        }
    }
    
    private func setupButtonColor() {
        favoriteButton.tintColor = .JEWDarkGray()
        if favoriteButton.isSelected {
            favoriteButton.tintColor = .JEWRed()
        }
    }
    
    @IBAction func favoriteTouched(_ sender: Any) {
        favoriteButton.isSelected = !favoriteButton.isSelected
        setupButtonColor()
        onFavorite?(characterID, favoriteButton.isSelected, characterImage.image)
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let size = UIScreen.main.bounds.size.width
        let defaultSize = CGSize(width: size/2 - 5, height: size/2 - 5)
        let landScapeSize = CGSize(width: size/3 - 5, height: size/3 - 5)
        switch UIDevice.current.orientation {
        case .unknown, .portrait, .portraitUpsideDown, .faceUp, .faceDown:
            return defaultSize
        case .landscapeLeft, .landscapeRight:
            return landScapeSize
        }
    }
    
}

