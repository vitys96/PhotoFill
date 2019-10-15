//
//  GalleryViewController.swift
//  PhotoFill
//
//  Created by Vitaly on 27/08/2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import UIKit
import CollectionKit
import SDWebImage

class GalleryViewController: CollectionViewController {
    
    var networkDataFetcher = NetworkDataFetcher()
    private var timer: Timer?
    private var photos = [UnsplashPhoto]()
    var searchController: UISearchController!
    
    let dataSource = ArrayDataSource(data: [UIImage]())
    let downloader = SDWebImageManager()
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidSelect))
    }()
    
    private lazy var actionBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButtonItemnDidSelect))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSearchBar()
//        configureCollectionView()
//        collectionView.fillSuperview()

        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let visibleFrameInsets = UIEdgeInsets(top: 0, left: -100, bottom: 0, right: -100)
        provider = BasicProvider(
            dataSource: dataSource,
            viewSource: ClosureViewSource(viewGenerator: { (data, index) -> UIImageView in
                let view = UIImageView()
                view.layer.cornerRadius = 5
                view.clipsToBounds = true
                return view
            }, viewUpdater: { (view: UIImageView, data: UIImage, at: Int) in
                view.image = data
            }),
            sizeSource: UIImageSizeSource(),
            layout: WaterfallLayout(columns: 2, spacing: 10).insetVisibleFrame(by: visibleFrameInsets),
            animator: WobbleAnimator()
        )
    }
    
    private func configureCollectionView() {
        
    }
    
    private func setupSearchBar() {
        
        searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.delegate = self
        
        self.definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.placeholder = "Найти фото"
        searchController.searchBar.sizeToFit()
        
        self.navigationItem.searchController = searchController
    }
    
    private func setupNavigationBar() {
        //        navigationController?.navigationBar.isTranslucent = false
        let titleLabel = UILabel()
        titleLabel.text = "PHOTOS"
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = #colorLiteral(red: 0.5019607843, green: 0.4980392157, blue: 0.4980392157, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItems = [actionBarButtonItem, addBarButtonItem]
    }
}

//MARK: - Objc Actions
extension GalleryViewController {
    @objc private func addButtonDidSelect() {
        
    }
    
    @objc private func actionButtonItemnDidSelect(sender: UIBarButtonItem) {
        
    }
}

//MARK: - UISearchBarDelegate
extension GalleryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.dataSource.data.removeAll()
            self.networkDataFetcher.fetchImages(searchText: searchText) { [weak self] (searchResults) in
                guard let self = self else { return }
                guard let fetchedPhotos = searchResults else { return }
                self.photos = fetchedPhotos.results
                let imagesUrls = self.photos.map({$0.urls["regular"]})
                for oneUrl in imagesUrls {
                    guard let imageUrl = oneUrl, let url = URL(string: imageUrl) else { return }
                    self.downloader.loadImage(with: url, options: [.retryFailed, .highPriority], progress: nil) { (image, _, _, _, _, _) in
                        self.dataSource.data.append(image!)
                    }
                }
            }
        })
    }
}
