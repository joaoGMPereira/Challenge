//
//  CharacterModel.swift
//  Challenge_Example
//
//  Created by Joao Gabriel Pereira on 06/05/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import JewFeatures

public struct CharacterViewModel {
    
    var id: Int
    var name: String
    //var photoULR: String
    var imagePath: String?
    var isFavorite: Bool
    var image: UIImage?
    
    init(_ character: Character, image: UIImage?) {
        self.id = character.id ?? -1
        self.name = character.name ?? String()
        //self.photoULR = character.thumbnail?.getURLPath() ?? String()
        self.isFavorite = character.isFavorited ?? false
        self.imagePath = character.imagePath
        self.image = image
    }
}


struct ReloadableCellCharacterItem: ReloadableItem {
    
    var characters: [Character]
    var images:[DownloadedImages]
    var height: CGFloat? {
        return nil
    }
    
    var sectionTitle: String? {
        return nil
    }
    
    var cellItems: [CellItem] {
        var items = [CellItem]()
        for character in characters {
            var characterID = String(describing: character)
            if let id = character.id {
                characterID = "\(id)"
            }
            
            let characterViewModel = CharacterViewModel(character, image: images.filter({$0.id == character.thumbnail?.getURLPath()}).first?.image)
            
            let item = CellItem(value: String(describing: character), object: characterViewModel, id: characterID, bundle: Bundle.main)
            items.append(item)
        }
        return items
    }
    
    var cellType: String {
        return CharacterCell.className
    }
    
    
}

struct DownloadedImages: Hashable {
static func == (lhs: DownloadedImages, rhs: DownloadedImages) -> Bool {
    return lhs.id == rhs.id && lhs.name == rhs.name
}
public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
}
    let image: UIImage?
    let id: String?
    let name: String?
}
