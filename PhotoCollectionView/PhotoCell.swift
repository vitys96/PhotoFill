//
//  PhotoCell.swift
//  PhotoFill
//
//  Created by Vitaly on 26/08/2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import UIKit
import SDWebImage


class PhotoCell: UICollectionViewCell {
    
    static let reuseId = "photoCell"
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override var isSelected: Bool {
        didSet {
            updateSelectedState()
        }
    }
    
    private let checkmark: UIImageView = {
        let image = UIImage(named: "checkmark")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    
    var unsplashPhoto: UnsplashPhoto! {
        didSet {
            let photoUrl = unsplashPhoto.urls["regular"]
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
            photoImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    override func prepareForReuse() {
        photoImageView.image = nil
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateSelectedState()
        setupUI()
    }
    
    private func updateSelectedState() {

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
            self.photoImageView.alpha = self.isSelected ? 0.7 : 1.0
            self.checkmark.alpha = self.isSelected ? 1.0 : 0.0
        }
    }
    
    private func setupUI() {
        photoImageView.layer.cornerRadius = 10
        photoImageView.clipsToBounds = true
        addSubview(photoImageView)
        addSubview(checkmark)
        photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        checkmark.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -8).isActive = true
        checkmark.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -8).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
