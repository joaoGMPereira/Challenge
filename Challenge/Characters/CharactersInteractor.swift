//
//  CharactersInteractor.swift
//  Challenge
//
//  Created by Joao Gabriel Pereira on 06/05/20.
//

import UIKit
import JewFeatures

protocol CharactersInteractorInterface {
    var images: [DownloadedImages] { get set }
    var characters: [Character] { get set }
    var searchName: String { get set }
    func fetchCharacters(searchName: String)
    func fetchCharacters()
    func updateFavoriteCharacters()
    func refreshCharacters()
    
    func addFavorite(with id: Int, and image: UIImage?)
    func removeFavorite(with id: Int)
    
}

class CharactersInteractor: CharactersInteractorInterface {
    
    //MARK: Properties
    var images = [DownloadedImages]()
    var characters = [Character]()
    var searchName = String()
    var presenter: CharactersPresenterInterface?
    var worker: CharactersWorkerInterface = CharactersWorker()
    
    private var offset = 0
    private var hasMore = true
    private var isLoading = false
    private let pageSize = 20
    
    func fetchCharacters() {
        checkGetCharacters(searchName: self.searchName, hasChangedSearch: false)
    }
    
    func fetchCharacters(searchName: String) {
        let hasChangeSearch = self.searchName != searchName
        self.searchName = searchName 
        checkGetCharacters(searchName: searchName, hasChangedSearch: hasChangeSearch)
    }
    
    func refreshCharacters() {
        self.offset = 0
        hasMore = true
        characters = [Character]()
        images = [DownloadedImages]()
        checkGetCharacters(searchName: self.searchName, hasChangedSearch: false)
    }
    
    func checkGetCharacters(searchName: String?, hasChangedSearch: Bool) {
        if JEWReachability.recheability.check() {
            let enableToGetCharacters = (hasMore && !isLoading) || hasChangedSearch
            if enableToGetCharacters {
                getCharacters(searchName: searchName, hasChangedSearch: hasChangedSearch)
            }
            return
        }
        presenter?.presentDisconnected()
    }
    
    private func getCharacters(searchName: String?, hasChangedSearch: Bool) {
        presenter?.presentStartLoading()
        if hasChangedSearch {
            self.offset = 0
            images = [DownloadedImages]()
        }
        self.isLoading = true
        worker.fetchCharacters(offset: offset, limit: pageSize, searchName: searchName, successCompletion: { (charactersResult) in
            self.successCompletion(charactersResult: charactersResult, hasChangedSearch: hasChangedSearch)
        }) { (connectorError) in
            self.isLoading = false
            self.presenter?.present(error: CharactersConstants.getCharacterError, alertType: .error)
        }
        
    }
    
    private func successCompletion(charactersResult: CharactersResult, hasChangedSearch: Bool) {
        self.isLoading = false
        self.offset += self.pageSize
        self.hasMore = self.offset < (charactersResult.data?.total ?? 0) && (charactersResult.data?.results?.count ?? 0) == self.pageSize
        guard let newCharacters = charactersResult.data?.results, newCharacters.count > 0 else {
            self.presenter?.present(error: CharactersConstants.notCharactersFoundError, alertType: .custom(messageColor: .white, backgroundColor: .JEWPallete(red: 241, green: 174, blue: 47)))
            return
        }
            if hasChangedSearch {
                self.characters = newCharacters
            } else {
                self.characters.append(contentsOf: newCharacters)
            }
        updateFavorites()
        downloadCharactersImages()
        self.presenter?.present(characters: characters, images: images)
    }
    
    private func updateFavorites() {
        CharactersConstants.favoritesKeyUserDefaults.getInDefaults() { (favoriteCharacters: [Character]?) in
            self.updateRemovedFavorites(favoriteCharacters: favoriteCharacters)
            self.updateAddedFavorites(favoriteCharacters: favoriteCharacters)
            
        }
    }
    
    private func updateAddedFavorites(favoriteCharacters: [Character]?) {
        favoriteCharacters?.forEach({ (favorited) in
            if let index = self.characters.firstIndex(where: {$0.id == favorited.id}), self.characters.count > index {
                self.characters[index] = favorited
            }
        })
    }
    
    private func updateRemovedFavorites(favoriteCharacters: [Character]?) {
        self.characters.forEach { (character) in
            if let index = self.characters.firstIndex(where: {$0.id == character.id}), self.characters.count > index {
                let updateNotFavoriteCharacter = Character.init(with: character, isFavorited: false, imagePath: nil)
                self.characters[index] = updateNotFavoriteCharacter
            }
        }
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
                } else {
                    worker.fetchCharactersImages(url: character.thumbnail?.getURLPath(), name: character.name) { (downloadedImage) in
                        self.images.append(downloadedImage)
                        self.images = self.images.filterDuplicates()
                        if(self.images.count == charactersCountWhenStartDownload) {
                            self.presenter?.present(characters: self.characters, images: self.images)
                        }
                    }
                }
            }
        }
    }
    
    func updateFavoriteCharacters() {
        updateFavorites()
        if isLoading == false {
            self.presenter?.present(characters: characters, images: images)
        }
    }
    
    func addFavorite(with id: Int, and image: UIImage?) {
        CharactersConstants.favoritesKeyUserDefaults.getInDefaults() { (favoriteCharacters: [Character]?) in
            var updatedFavorites = [Character]()
            if let favorites = favoriteCharacters {
                updatedFavorites = favorites
            }
            
            if let favorited = self.characters.filter({$0.id == id}).first {
                let imagePath = "\(favorited.id ?? 0)"
                image?.addImageToFileManager(id: imagePath)
                let updatedFavorited = Character(with: favorited, isFavorited: true, imagePath: imagePath)
                updatedFavorites.append(updatedFavorited)
            }
            
            updatedFavorites = updatedFavorites.filterDuplicates()
            updatedFavorites.saveInDefaults(in: CharactersConstants.favoritesKeyUserDefaults)
        }
        updateFavorites()
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
    }
}
