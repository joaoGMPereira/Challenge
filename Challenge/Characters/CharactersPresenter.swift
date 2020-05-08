//
//  CharactersPresenter.swift
//  Challenge
//
//  Created by Joao Gabriel Pereira on 06/05/20.
//
import JewFeatures

protocol CharactersPresenterInterface {
    func present(characters: [Character], images: [DownloadedImages])
    func present(error: String, alertType: JEWPopupMessageType)
    func presentDisconnected()
    func presentStartLoading()
}

class CharactersPresenter: CharactersPresenterInterface {
    
    //MARK: Properties
    weak var viewController: CharactersViewControllerInterface?
    
    func present(characters: [Character], images: [DownloadedImages]) {
        viewController?.displayStopLoading()
        guard characters.count > 0 else {
            viewController?.display(error: CharactersConstants.notCharactersFoundError, alertType: .custom(messageColor: .white, backgroundColor: .JEWPallete(red: 241, green: 174, blue: 47)))
            return
        }
        viewController?.display(characters: [ReloadableCellCharacterItem(characters: characters, images: images)])
    }
    
    func present(error: String, alertType: JEWPopupMessageType) {
        viewController?.displayStopLoading()
        viewController?.display(error: error, alertType: alertType)
    }
    
    func presentDisconnected() {
        viewController?.displayDisconnected()
    }
    
    func presentStartLoading() {
        viewController?.displayStartLoading()
    }
    
}
