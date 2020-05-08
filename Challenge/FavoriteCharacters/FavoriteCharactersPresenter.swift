//
//  FavoriteCharactersPresenter.swift
//  Challenge
//
//  Created by Joao Gabriel Pereira on 06/05/20.
//

import JewFeatures

protocol FavoriteCharactersPresenterInterface {
    func present(characters: [Character], images: [DownloadedImages])
    func present(error: String)
}

class FavoriteCharactersPresenter: FavoriteCharactersPresenterInterface {
    
    //MARK: Properties
    weak var viewController: FavoriteCharactersViewControllerInterface?
    
    func present(characters: [Character], images: [DownloadedImages]) {
        guard characters.count > 0 else {
            viewController?.display(error: FavoriteCharactersConstants.noFavorites, alertType: .error)
            return
        }
        viewController?.display(characters: [ReloadableCellCharacterItem(characters: characters, images: images)])
    }
    
    func present(error: String) {
        viewController?.display(error: error, alertType: .error)
    }
}
