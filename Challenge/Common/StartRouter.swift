//
//  StartRouter.swift
//  Challenge_Example
//
//  Created by Joao Gabriel Pereira on 06/05/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import JewFeatures
import PodAsset

protocol StartRouterProtocol {
    static func goToApp()
}

class StartRouter: StartRouterProtocol {
    
    static func goToApp() {
        var navigationControllers = [UINavigationController]()
        
        let charactersTabBarImage = UIImage(named: AppConstants.charactersTabImageName, in: Bundle.main, compatibleWith: nil)
        let favoritesTabBarImage = UIImage(named: AppConstants.favoriteTabImageName, in: Bundle.main, compatibleWith: nil)
        
        let charactersViewController = CharactersRouter.createModule()
        charactersViewController.background = UIColor.JEWLightGray()
        let charactersTabBarItem = UITabBarItem(title: CharactersConstants.tabName, image: charactersTabBarImage, tag: 0)
        charactersViewController.tabBarItem = charactersTabBarItem
        let charactersNavigationController = UINavigationController.init(rootViewController: charactersViewController)
        navigationControllers.append(charactersNavigationController)
        
        let favoriteCharactersViewController = FavoriteCharactersRouter.createModule()
        favoriteCharactersViewController.background = UIColor.JEWLightGray()
        let favoriteCharactersTabBarItem = UITabBarItem(title: FavoriteCharactersConstants.tabName, image: favoritesTabBarImage, tag: 1)
        favoriteCharactersViewController.tabBarItem = favoriteCharactersTabBarItem
        let favoriteCharactersNavigationController = UINavigationController.init(rootViewController: favoriteCharactersViewController)
        navigationControllers.append(favoriteCharactersNavigationController)
        
        AppDelegate.shared.tabBarController.setViewControllers(navigationControllers, animated: true)
        AppDelegate.shared.tabBarController.tabBar.isHidden = false
        AppDelegate.shared.window?.rootViewController = AppDelegate.shared.tabBarController
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
}
