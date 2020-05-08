//
//  FavoriteCharactersRouter.swift
//  Challenge
//
//  Created by Joao Gabriel Pereira on 06/05/20.
//

import UIKit

protocol FavoriteCharactersRouterInterface {
    func goToCharacters()
    func goToDetail(index: Int)
}

class FavoriteCharactersRouter: FavoriteCharactersRouterInterface {
    
    //MARK: Properties
    weak var viewController: FavoriteCharactersViewController?
    
    static func createModule() -> FavoriteCharactersViewController {
        let view = FavoriteCharactersViewController()
        let presenter = FavoriteCharactersPresenter()
        presenter.viewController = view
        let interactor = FavoriteCharactersInteractor()
        view.interactor = interactor
        interactor.presenter = presenter
        let router = FavoriteCharactersRouter()
        view.router = router
        router.viewController = view
        
        return view
    }
    
    func goToCharacters() {
        AppDelegate.shared.tabBarController.selectedIndex = 0
    }
    
    func goToDetail(index: Int) {
        if let interactor = viewController?.interactor, interactor.characters.count > index {
            let character = interactor.characters[index]
            let detailViewController = DetailCharacterRouter.createModule(character: character)
            viewController?.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
}
