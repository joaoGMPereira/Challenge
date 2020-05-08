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
    var photoULR: String
    var imagePath: String?
    var isFavorite: Bool
    
    init(_ character: Character) {
        self.id = character.id ?? -1
        self.name = character.name ?? String()
        self.photoULR = character.thumbnail?.getURLPath() ?? String()
        self.isFavorite = character.isFavorited ?? false
        self.imagePath = character.imagePath
    }
}


struct ReloadableCellCharacterItem: ReloadableItem {
    
    var characters: [Character]
    
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
            
            let characterViewModel = CharacterViewModel(character)
            
            let item = CellItem(value: String(describing: character), object: characterViewModel, id: characterID, bundle: Bundle.main)
            items.append(item)
        }
        return items
    }
    
    var cellType: String {
        return CharacterCell.className
    }
    
    
}
