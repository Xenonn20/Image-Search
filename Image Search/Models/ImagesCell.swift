//
//  ImagesCell.swift
//  Image Search
//
//  Created by Кирилл Медведев on 19/09/2019.
//  Copyright © 2019 Kirill Medvedev. All rights reserved.
//

import UIKit
import SDWebImage

class ImagesCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseID = "ImagesCell"
    
    private let checkmark: UIImageView = {
        let image = UIImage(named: "circle-tick-7")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var unsplashImage: UnsplashImage! {
        didSet {
            let imageUrl = unsplashImage.urls["regular"]
            guard let image = imageUrl, let url = URL(string: image) else { return }
            
            photoImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateSelectedState()
        }
    }
    // MARK: - Functions
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    private func setupPhotoImageView() {
        addSubview(photoImageView)
        photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    private func setupCheckmarkView() {
    addSubview(checkmark)
        checkmark.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -8).isActive = true
        checkmark.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: -8).isActive = true
    }
    
    private func updateSelectedState() {
        photoImageView.alpha = isSelected ? 0.7 : 1
        checkmark.alpha = isSelected ? 1: 0
    }
    
    // MARK: - initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        updateSelectedState()
        setupPhotoImageView()
        setupCheckmarkView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
