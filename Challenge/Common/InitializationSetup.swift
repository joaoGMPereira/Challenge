//
//  InitializationSetup.swift
//  Challenge_Example
//
//  Created by Joao Gabriel Pereira on 06/05/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import JewFeatures

struct InitializationSetup {
    
    static func setup() {
        JEWConnector.connector.baseURL = MarvelRequests.domain
        setupColors()
        StartRouter.goToApp()
    }
    
    static func setupColors() {
        JEWUIColor.default.defaultColor = UIColor.JEWRed()
        UINavigationBar.appearance().tintColor = JEWUIColor.default.defaultColor
        AppDelegate.shared.tabBarController.tabBar.tintColor = JEWUIColor.default.defaultColor
        UITextField.appearance().tintColor = JEWUIColor.default.defaultColor
    }
    
    static func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

}
