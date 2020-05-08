//
//  ItemDetailCharacterCell.swift
//  Challenge_Example
//
//  Created by Joao Gabriel Pereira on 07/05/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JewFeatures
import Lottie
import PodAsset

class ItemDetailCharacterCell: UICollectionViewCell , ReloadableCellProtocol {
    
    @IBOutlet weak var roundedContentView: UIView!
    @IBOutlet weak var contentImageView: UIView!

    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterImage: UIImageView!
    var loadingView = AnimationView()
    var item: CellItem?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterImage.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        roundedContentView.round(radius: 8, backgroundColor: .white, borderColor: .JEWPallete(red: 230, green: 230, blue: 230), borderWidth: 1, withShadow: true)
    }
    
    func set(item: CellItem?, row: Int) {
        if let items = item?.object as? Items {
            layoutIfNeeded()
            setupLottie()
            setupLabel(items)
            self.characterImage.tintColor = .JEWDefault()
            setupImage(items)
        }
    }
    
    private func setupLabel(_ items: Items) {
        characterNameLabel.text = items.title
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
    
    private func setupImage(_ items: Items) {
        characterImage.image = nil
        self.loadingView.isAnimated(isHidden: false)
        self.characterImage.isAnimated(isHidden: true)
        self.loadingView.play()
        self.characterImage?.downloaded(from: items.thumbnail?.getURLPath() ?? String(), contentMode: .scaleAspectFit) { image, url in
            self.characterImage.image = image
            self.loadingView.stop()
            self.loadingView.isAnimated(isHidden: true)
            self.characterImage.isAnimated(isHidden: false)
        }
    }
    
    func didSelected() {
           
       }
       
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return CGSize.init(width: 200, height: 300)
    }
    
}

