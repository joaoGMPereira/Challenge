//
//  ReloadableDetailItem.swift
//  Challenge_Example
//
//  Created by Joao Gabriel Pereira on 07/05/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import JewFeatures

struct ReloadableSectionComicsItem: ReloadableItem {
    var height: CGFloat? {
        return heightParent
    }
    
    var comics: [Comics]
    var heightParent: CGFloat
    
    var sectionTitle: String? {
        return "Comics"
    }
    
    var cellItems: [CellItem] {
        var items = [CellItem]()
        let reloadableCell = ReloadableCellDetailItem(detailItems: comics, parentHeight: heightParent)
        let item = CellItem(value: String(describing: comics), object: reloadableCell, id: sectionTitle ?? String(), bundle: JEWSession.bundle)
        items.append(item)
        return items
    }
    
    var cellType: String {
        return ReloadableTableViewCell.className
    }
}

struct ReloadableSectionSeriesItem: ReloadableItem {
    var height: CGFloat? {
        return heightParent
    }
    
    var series: [Series]
    var heightParent: CGFloat
    
    var sectionTitle: String? {
        return "Series"
    }
    
    var cellItems: [CellItem] {
        var items = [CellItem]()
        let reloadableCell = ReloadableCellDetailItem(detailItems: series, parentHeight: heightParent)
        let item = CellItem(value: String(describing: series), object: reloadableCell, id: sectionTitle ?? String(), bundle: JEWSession.bundle)
        items.append(item)
        return items
    }
    
    var cellType: String {
        return ReloadableTableViewCell.className
    }
}

struct ReloadableCellDetailItem: ReloadableItem {
    var height: CGFloat? {
        return parentHeight
    }
    
    var scrollDirection: UICollectionView.ScrollDirection? {
        return nil
    }
    
    var detailItems: [Items]?
    var parentHeight: CGFloat
    var sectionTitle: String? {
        return nil
    }
    
    var cellItems: [CellItem] {
        var items = [CellItem]()
        if let detailItems = detailItems {
            for item in detailItems {
                let item = CellItem(value: String(describing: item), object: item, id: item.title ?? String(), bundle: Bundle.main)
                items.append(item)
            }
        }
        return items
    }
    
    var cellType: String {
        return ItemDetailCharacterCell.className
    }
    
    
}
