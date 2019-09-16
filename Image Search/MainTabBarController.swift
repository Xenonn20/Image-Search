//
//  MainTabBarController.swift
//  Image Search
//
//  Created by Кирилл Медведев on 16/09/2019.
//  Copyright © 2019 Kirill Medvedev. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imagesVC = ImagesCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        viewControllers = [generateNavigationController(rootViewController: imagesVC, title: "Images", image: #imageLiteral(resourceName: "photos-simple-7")),
                           generateNavigationController(rootViewController: ViewController(), title: "Favourites", image: #imageLiteral(resourceName: "heart-7"))]
    }
    
    private func generateNavigationController(rootViewController: UIViewController,
                                              title: String,
                                              image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        
        return navigationVC
    }
}
