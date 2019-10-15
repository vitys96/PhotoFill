//
//  PhotoCollectVC.swift
//  PhotoFill
//
//  Created by Vitaly on 21/08/2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import UIKit
import SimpleImageViewer

class PhotoCollectVC: UICollectionViewController {
    
    var networkDataFetcher = NetworkDataFetcher()
    private var timer: Timer?
    private var photos = [UnsplashPhoto]()
    var searchController: UISearchController!
    var selectedImages = [UIImage]()
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidSelect))
    }()
    
    private lazy var actionBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionButtonItemnDidSelect))
    }()
    private lazy var selectBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Выбрать", style: .plain, target: self, action: #selector(selectButtonDidSelect))
    }()
    private lazy var cancelBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelButtonDidSelect))
    }()
    private var numberOfSelectedPhotos: Int {
        return collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        setupCollectionView()
        setupNavigationBar()
        setupSearchBar()
    }
    
    private func setupCollectionView() {
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseId)
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsSelection = true
        collectionView.showsVerticalScrollIndicator = false
        
        if let waterfallLayout = collectionViewLayout as? WaterfalllLayout {
            waterfallLayout.delegate = self
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItems = [selectBarButtonItem]
        navigationItem.rightBarButtonItems = nil
        refreshSelectedItems()
    }
    
    private func setupSearchBar() {
        
        searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.delegate = self
        self.definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Найти фото"
        self.navigationItem.searchController = searchController
    }
    
    func refreshSelectedItems() {
        selectedImages.removeAll()
        collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        collectionView.allowsMultipleSelection = false
    }
}

//MARK: - Objc Actions
extension PhotoCollectVC {
    
    @objc private func cancelButtonDidSelect() {
        setupNavigationBar()
    }
    @objc private func selectButtonDidSelect() {
        collectionView.allowsMultipleSelection = true
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItems = [actionBarButtonItem, addBarButtonItem]
    }
    
    @objc private func addButtonDidSelect() {
        let selectedPhotos = collectionView.indexPathsForSelectedItems?.reduce([], { (photosss, indexPath) -> [UnsplashPhoto] in
            var mutablePhotos = photosss
            let photo = photos[indexPath.item]
            mutablePhotos.append(photo)
            return mutablePhotos
        })
        
        let alertController = UIAlertController(title: "", message: "\(selectedPhotos!.count) фото будут добавлены в альбом", preferredStyle: .alert)
        let add = UIAlertAction(title: "Добавить", style: .default) { (action) in
            let tabbar = self.tabBarController as! MainTabBarController
            let navVC = tabbar.viewControllers?[1] as! UINavigationController
            let likesVC = navVC.topViewController as! LikesCollectionViewController
            
            likesVC.photos.append(contentsOf: selectedPhotos ?? [])
            likesVC.collectionView.reloadData()
            
            self.setupNavigationBar()
        }
        let cancel = UIAlertAction(title: "Отменить", style: .cancel) { (action) in
        }
        alertController.addAction(add)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    @objc private func actionButtonItemnDidSelect(sender: UIBarButtonItem) {
        
        let items = selectedImages
        let shareController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        shareController.completionWithItemsHandler = { _, bool, _, _ in
            if bool {
                self.setupNavigationBar()
            }
        }
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        self.present(shareController, animated: true, completion: nil)
    }
}

//MARK: - CollectionView DataSource, Delegates
extension PhotoCollectVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseId, for: indexPath) as? PhotoCell
            else { fatalError() }
        let unspashPhoto = photos[indexPath.item]
        cell.unsplashPhoto = unspashPhoto
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
        if collectionView.allowsMultipleSelection == true {
            guard let image = cell.photoImageView.image  else { return }
            selectedImages.append(image)
        } else {
            refreshSelectedItems()
            let configuration = ImageViewerConfiguration { config in
                config.imageView = cell.photoImageView
            }
            
            present(ImageViewerController(configuration: configuration), animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
        guard let image = cell.photoImageView.image  else { return }
        if let index = selectedImages.firstIndex(of: image) {
            selectedImages.remove(at: index)
        }
    }
}

//MARK: - UISearchBarDelegate
extension PhotoCollectVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.networkDataFetcher.fetchImages(searchText: searchText) { [weak self] (searchResults) in
                guard let fetchedPhotos = searchResults else { return }
                self?.photos = fetchedPhotos.results
                self?.collectionView.reloadData()
                self?.refreshSelectedItems()
            }
        })
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        refreshSelectedItems()
    }
}

// MARK: - WaterfallLayoutDelegate
extension PhotoCollectVC: WaterfallLayoutDelegate {
    func waterfallLayout(_ layout: WaterfalllLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let photo = photos[indexPath.item]
        return CGSize(width: photo.width, height: photo.height)
    }
}
