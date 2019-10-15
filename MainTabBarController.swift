//
//  MainTabBarController.swift
//  PhotoFill
//
//  Created by Vitaly on 21/08/2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let photosVC = PhotoCollectVC(collectionViewLayout: WaterfalllLayout())
        let likesVC = LikesCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        viewControllers = [
            generateNavController(rootVC: photosVC, title: "Photos", image: #imageLiteral(resourceName: "photos")),
            generateNavController(rootVC: likesVC, title: "Favourite", image: #imageLiteral(resourceName: "heart"))
        ]
    }
    
    private func generateNavController(rootVC: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootVC)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        
        return navigationVC
    }
    
    
}
