//
//  FavoriteCharactersInteractor.swift
//  Challenge
//
//  Created by Joao Gabriel Pereira on 06/05/20.
//

import UIKit
import JewFeatures

protocol FavoriteCharactersInteractorInterface {
    var sections: Int { get set }
    var characters: [Character] { get set }
    var images: [DownloadedImages] { get set }
    var searchName: String { get set }
    func fetchCharacters(searchName: String)
    func fetchCharacters()
    func removeFavorite(with id: Int)
    
}

class FavoriteCharactersInteractor: FavoriteCharactersInteractorInterface {
    
    //MARK: Properties
    var sections = 0
    var characters = [Character]()
    var images = [DownloadedImages]()
    var searchName = String()
    var presenter: FavoriteCharactersPresenterInterface?
    var worker: FavoriteCharactersWorker = FavoriteCharactersWorker()
    
    func fetchCharacters() {
        worker.fetchCharacters(searchText: self.searchName, successCompletion: { (characters) in
            self.characters = characters
            self.downloadCharactersImages()
        }) { (connectorError) in
            self.presenter?.present(error: connectorError)
        }

    }
    
    func fetchCharacters(searchName: String) {
        self.searchName = searchName
        fetchCharacters()
    }
    private func updateFavorites() {
        CharactersConstants.favoritesKeyUserDefaults.getInDefaults() { (favoriteCharacters: [Character]?) in
            if let favorites = favoriteCharacters {
                self.characters = favorites
            }
        }
    }
    
    func removeFavorite(with id: Int) {
        CharactersConstants.favoritesKeyUserDefaults.getInDefaults() { (favoriteCharacters: [Character]?) in
            var updatedFavorites = [Character]()
            if let favorites = favoriteCharacters {
                updatedFavorites = favorites
            }
            if let favoritedToBeRemoved = self.characters.filter({$0.id == id}).first, let index = updatedFavorites.firstIndex(where: { $0.id == favoritedToBeRemoved.id}) {
                updatedFavorites.remove(at: index)
            }
            
            updatedFavorites.saveInDefaults(in: CharactersConstants.favoritesKeyUserDefaults)
        }
        updateFavorites()
        self.presenter?.present(characters: characters, images: images)
    }
    
    func downloadCharactersImages() {
        let charactersCountWhenStartDownload = self.characters.count
        var teste = 0
        for character in self.characters {
            if images.filter({$0.name == character.name}).count == 0 {
                teste += 1
                print(teste)
                if let imagePath = character.imagePath {
                    imagePath.getImageFromFileManager { (image) in
                        self.images.append(DownloadedImages(image: image, id: character.thumbnail?.getURLPath(), name: character.name))
                        self.images = self.images.filterDuplicates()
                        if(self.images.count == charactersCountWhenStartDownload) {
                            self.presenter?.present(characters: self.characters, images: self.images)
                        }
                    }
                }
            }
        }
    }
}
