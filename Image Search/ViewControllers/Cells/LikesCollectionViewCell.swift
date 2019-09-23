//
//  LikesCollectionViewCell.swift
//  Image Search
//
//  Created by Кирилл Медведев on 21/09/2019.
//  Copyright © 2019 Kirill Medvedev. All rights reserved.
//

import UIKit
import SDWebImage

class LikesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseID = "LikesCell"
    
    private let checkmark: UIImageView = {
        let image = UIImage(named: "checkmark")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    
    var myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .green
        return imageView
    }()
    
    var unsplashImage: UnsplashImage! {
        
        didSet {
            let photoURL = unsplashImage.urls["regular"]
            guard let imageURL = photoURL, let url = URL(string: imageURL) else { return }
            myImageView.sd_setImage(with: url, completed: nil)
            
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
        myImageView.image = nil
    }
    
    private func setupImageView() {
        addSubview(myImageView)
        
        myImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        myImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        myImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        myImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func setupCheckmarkView() {
    addSubview(checkmark)
        checkmark.trailingAnchor.constraint(equalTo: myImageView.trailingAnchor, constant: -8).isActive = true
        checkmark.bottomAnchor.constraint(equalTo: myImageView.bottomAnchor, constant: -8).isActive = true
    }
    
    private func updateSelectedState() {
        myImageView.alpha = isSelected ? 0.7 : 1
        checkmark.alpha = isSelected ? 1 : 0
    }
    
    // MARK: - initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        myImageView.backgroundColor = .green
        setupImageView()
        setupCheckmarkView()
        updateSelectedState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
