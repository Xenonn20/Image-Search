//
// LikesCollectionViewController.swift
//  Image Search
//
//  Created by Кирилл Медведев on 16/09/2019.
//  Copyright © 2019 Kirill Medvedev. All rights reserved.
//

import UIKit

class LikesCollectionViewController: UICollectionViewController {
    
    //MARK: - Stored properties
    
    var images = [UnsplashImage]()
    
    //MARK: - Computed properties
    
    private lazy var trashBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteImage))
    }()
    
    private var enterSearchTermLabel: UILabel = {
        let label = UILabel()
        label.text = "You haven't add a photos yet"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var numberOfSelectedPhotos: Int {
          return collectionView.indexPathsForSelectedItems?.count ?? 0
      }
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.register(LikesCollectionViewCell.self, forCellWithReuseIdentifier: LikesCollectionViewCell.reuseID)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        collectionView.allowsMultipleSelection = true
        
        setupNavigationBar()
        setupEnterLabel()
        setupLayout()
        updateNaviButtonState()
    }
    
    private func updateNaviButtonState() {
           trashBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
           
       }
    // MARK: - Setup UI Elements
    
    private func setupEnterLabel() {
        collectionView.addSubview(enterSearchTermLabel)
        enterSearchTermLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        enterSearchTermLabel.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 50).isActive = true
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Favourites"
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = .gray
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItem = trashBarButtonItem
        trashBarButtonItem.isEnabled = false
    }
    @objc func deleteImage() {
        guard let indexPath = collectionView.indexPathsForSelectedItems else { return }
        self.images.remove(at: indexPath[0].item)
        collectionView.deleteItems(at: indexPath)
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        enterSearchTermLabel.isHidden = images.count != 0
        return images.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikesCollectionViewCell.reuseID, for: indexPath) as! LikesCollectionViewCell
        let unsplashImage = images[indexPath.item]
        cell.unsplashImage = unsplashImage
    return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        updateNaviButtonState()
    }
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateNaviButtonState()
    }
}

// MARK: - UICollectionViewFlowLayout

extension LikesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width / 3 - 1, height: width / 3 - 1)
    }
    
    private func setupLayout() {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
    }
}
