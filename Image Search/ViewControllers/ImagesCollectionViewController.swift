//
//  ImagesCollectionViewController.swift
//  Image Search
//
//  Created by Кирилл Медведев on 16/09/2019.
//  Copyright © 2019 Kirill Medvedev. All rights reserved.
//

import UIKit

class ImagesCollectionViewController: UICollectionViewController {
    
    //MARK: - Stored properties
    
    let networkDataFetcher = NetworkDataFetcher()
    private var timer: Timer?
    private var images = [UnsplashImage]()
    private let itemsPerRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    private var selectedImages = [UIImage]()
    
    //MARK: - Computed properties
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
    }()
    
    private lazy var actionBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionBarButtonTapped))
    }()
    
    private var numberOfSelectedPhotos: Int {
        return collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
        let spiner = UIActivityIndicatorView(style: .gray)
        spiner.translatesAutoresizingMaskIntoConstraints = false
        return spiner
    }()
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        setupCollectionView()
        setupNavigationBar()
        setupSearchBar()
        updateNaviButtonState()
        setupActivityIndicator()
    }
    private func updateNaviButtonState() {
        addBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
        actionBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
    }
    
    private func refresh() {
        self.selectedImages.removeAll()
        self.collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        updateNaviButtonState()
    }
    
    // MARK: - NavigationItems action
    
    @objc private func addBarButtonTapped() {
        let selectedImage = collectionView.indexPathsForSelectedItems?.reduce([], { (photoss, IndexPath) -> [UnsplashImage] in
            var mutableImage = photoss
            let image = images[IndexPath.item]
            mutableImage.append(image)
            return mutableImage
        })
        let alertController = UIAlertController(title: "", message: "\(selectedImage!.count) images will be added to the album", preferredStyle: .alert)
        
        let add = UIAlertAction(title: "Add", style: .default) { (action) in
            let tabbar = self.tabBarController as! MainTabBarController
            let navVC = tabbar.viewControllers?[1] as! UINavigationController
            let likeVC = navVC.topViewController as! LikesCollectionViewController
            
            likeVC.images.append(contentsOf: selectedImage ?? [])
            likeVC.collectionView.reloadData()
            
            self.refresh()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
            self.refresh()
        }
        
        alertController.addAction(add)
        alertController.addAction(cancel)
        
        
        present(alertController, animated: true)
    }
    
    @objc private func actionBarButtonTapped(sender: UIBarButtonItem) {
        
        let shareControllet = UIActivityViewController(activityItems: selectedImages, applicationActivities: nil)
        shareControllet.completionWithItemsHandler = { _, bool, _, _ in
            if bool {
                self.refresh()
            }
        }
        shareControllet.popoverPresentationController?.barButtonItem = sender
        shareControllet.popoverPresentationController?.permittedArrowDirections = .any
        
        present(shareControllet, animated: true, completion: nil)
    }
    
    // MARK: - Setup UI Elements
    
    private func setupCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(ImagesCell.self, forCellWithReuseIdentifier: ImagesCell.reuseID)
        
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Images"
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = #colorLiteral(red: 0.502007544, green: 0.4980560541, blue: 0.4979303479, alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItems = [actionBarButtonItem, addBarButtonItem]
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setupActivityIndicator() {
        collectionView.addSubview(activityIndicator)
        
        activityIndicator.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesCell.reuseID, for: indexPath) as! ImagesCell
        let unsplashImage = images[indexPath.item]
        cell.unsplashImage = unsplashImage
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateNaviButtonState()
        let cell = collectionView.cellForItem(at: indexPath) as! ImagesCell
        guard let image = cell.photoImageView.image else { return }
        selectedImages.append(image)
        
    }
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateNaviButtonState()
        let cell = collectionView.cellForItem(at: indexPath) as! ImagesCell
        guard let image = cell.photoImageView.image else { return }
        if let index = selectedImages.firstIndex(of: image) {
            selectedImages.remove(at: index)
        }
    }
    
}

// MARK: - UISearchBarDelegate

extension ImagesCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.activityIndicator.startAnimating()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.networkDataFetcher.fetchImages(searchTerm: searchText) { [weak self](searchResults) in
                guard let fetchedImages = searchResults else { return }
                self?.activityIndicator.stopAnimating()
                self?.images = fetchedImages.results
                self?.collectionView.reloadData()
                self?.refresh()
            }
        })
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ImagesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let image = images[indexPath.item]
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let height = CGFloat(image.height) * widthPerItem / CGFloat(image.width)
        return CGSize(width: widthPerItem, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}
