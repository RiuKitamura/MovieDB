//
//  MainTabController.swift
//  MovieDB
//
//  Created by M Habib Ali Akbar on 01/06/21.
//

import UIKit

class MainTabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .dbBackground
        overrideUserInterfaceStyle = .dark
        configureViewControllers()
    }

    private func configureViewControllers() {
        
        self.tabBar.tintColor = .dbYellow
        
        let homePage = HomeViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = templateNavigationController(image: UIImage(named: "Home"), rootViewController: homePage)
        
        let popularPage = PopularViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav2 = templateNavigationController(image: UIImage(named: "Bages"), rootViewController: popularPage)
        
        let favoritePage = FavoriteViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav3 = templateNavigationController(image: UIImage(named: "Heart"), rootViewController: favoritePage)
        
        self.viewControllers = [nav1, nav2, nav3]
    }
    
    private func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.navigationBar.tintColor = .dbYellow
        nav.tabBarItem.image = image
        nav.tabBarItem.imageInsets = UIEdgeInsets(top: 14, left: 0, bottom: -14, right: 0)
        return nav
    }
}
