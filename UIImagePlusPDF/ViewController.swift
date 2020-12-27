//
//  ViewController.swift
//  UIImagePlusPDF
//
//  Created by Dima Mishchenko on 16.05.2018.
//  Copyright © 2018 Dima. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemTeal
        
        /**
        * Caching options:
        *
        * - Memory: UIImage.pdfCacheInMemory = true
        * - Disk:   UIImage.pdfCacheOnDisk = true
        */
        
        guard let image = UIImage.pdfImage(with: "dora", width: 350) else { return }
        
        /**
        * Other options:
        *
        * - Original PDF size:      UIImage.pdfImage(with: "dora")
        *
        * - With custom width:      UIImage.pdfImage(with: "dora", width: 350)
        *
        * - With custom height:     UIImage.pdfImage(with: "dora", height: 350)
        *
        * - With custom size:       UIImage.pdfImage(with: "dora", size: CGSize(width: 300, height:  400))
        *
        * - With page number:       UIImage.pdfImage(with: "multipage pdf file", width: 300, pageNumber: 2)
        *
        * - Same with resource url: UIImage.pdfImage(with: URL(string: "path"))
        *
        */
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        imageView.image = image
        imageView.center = view.center
        view.addSubview(imageView)
    }

}

