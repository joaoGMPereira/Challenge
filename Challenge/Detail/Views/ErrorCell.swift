//
//  ErrorCell.swift
//  Challenge_Example
//
//  Created by Joao Gabriel Pereira on 08/05/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import JewFeatures

class ErrorCell: UICollectionViewCell, ReloadableCellProtocol {
    var item: CellItem?
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func set(item: CellItem?, row: Int) {
        if let title = item?.object as? String {
            label.text = title
            label.textColor = .JEWRed()
            label.font = .JEW20Bold()
        }
    }
    
    func didSelected() {
        
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width, height: 200)
    }
}
