//
//  FavoriteCharactersViewController+CollectionView.swift
//  Challenge_Example
//
//  Created by Joao Gabriel Pereira on 07/05/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit


extension FavoriteCharactersViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.interactor?.characters.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let sections = interactor?.sections {
            return sections
        }
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: CharacterCell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.className, for: indexPath) as? CharacterCell {
            if let interactor = interactor, interactor.characters.count > indexPath.row {
                let character = interactor.characters[indexPath.row]
                cell.setup(CharacterViewModel.init(character, image: interactor.images.filter({$0.id == character.thumbnail?.getURLPath()}).first?.image))
            }
            
            cell.onFavorite = { [unowned self] (characterID, isAdding, image) in
                if isAdding == false {
                    self.interactor?.removeFavorite(with: characterID)
                }
                
            }
            
            return cell
        }
        
        return UICollectionViewCell(frame: .zero)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.router?.goToDetail(index: indexPath.row)
    }
}
