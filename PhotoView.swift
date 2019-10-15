//
//  PhotoView.swift
//  PhotoFill
//
//  Created by Vitaly on 27/08/2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import UIKit

class PhotoView: UIView {
    let colorView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func download(data: PhotoData) {
        
    }
    
}
