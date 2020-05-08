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
        return nil
    }
    
    var comics: [Comics]
    var errorTitle: String
    
    var sectionTitle: String? {
        return "Comics"
    }
    
    var cellItems: [CellItem] {
        var items = [CellItem]()
        let reloadableCell = ReloadableCellDetailItem(detailItems: comics, errorTitle: errorTitle)
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
        return nil
    }
    
    var series: [Series]
    var errorTitle: String
    
    var sectionTitle: String? {
        return "Series"
    }
    
    var cellItems: [CellItem] {
        var items = [CellItem]()
        let reloadableCell = ReloadableCellDetailItem(detailItems: series, errorTitle: errorTitle)
        let item = CellItem(value: String(describing: series), object: reloadableCell, id: sectionTitle ?? String(), bundle: JEWSession.bundle)
        items.append(item)
        return items
    }
    
    var cellType: String {
        return ReloadableTableViewCell.className
    }
}

struct ReloadableCellDetailItem: ReloadableItem {
    let cellHeight: CGFloat = 300
    let errorCellHeight: CGFloat = 200
    var height: CGFloat? {
        return detailItems?.count ?? 0 > 0 ? cellHeight : errorCellHeight
    }
    
    var scrollDirection: UICollectionView.ScrollDirection? {
        return nil
    }
    
    var detailItems: [Items]?
    var errorTitle: String
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
        
        if detailItems?.count == 0 {
            let item = CellItem(value: String(describing: errorTitle), object: errorTitle, id: errorTitle, bundle: Bundle.main)
            items.append(item)
        }
        
        return items
    }
    
    var cellType: String {
        if detailItems?.count == 0 {
            return ErrorCell.className
        }
        return ItemDetailCharacterCell.className
    }
    
    
}
