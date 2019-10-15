//
//  CollectionViewController.swift
//  PhotoFill
//
//  Created by Vitaly on 27/08/2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import UIKit
import CollectionKit

class CollectionViewController: UIViewController {
    let collectionView = CollectionView()
    
    var provider: Provider? {
        get { return collectionView.provider }
        set { collectionView.provider = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}
