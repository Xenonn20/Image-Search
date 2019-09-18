//
//  ImagesCollectionViewController.swift
//  Image Search
//
//  Created by Кирилл Медведев on 16/09/2019.
//  Copyright © 2019 Kirill Medvedev. All rights reserved.
//

import UIKit

class ImagesCollectionViewController: UICollectionViewController {
    
    let networkDataFetcher = NetworkDataFetcher()
    private var timer: Timer?
    private var images = [UnsplashImage]()
    //MARK: - Properties
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
    }()
    private lazy var actionBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionBarButtonTapped))
    }()
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = #colorLiteral(red: 1, green: 0.5745739937, blue: 0.001978197834, alpha: 1)
        setupCollectionView()
        setupNavigationBar()
        setupSearchBar()
    }
    
    // MARK: - NavigationItems action
    
    @objc private func addBarButtonTapped() {
        
    }
    
    @objc private func actionBarButtonTapped() {
        
    }
    
    // MARK: - Setup UI Elements
    
    private func setupCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(ImagesCell.self, forCellWithReuseIdentifier: ImagesCell.reuseID)
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
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        
        
    }
    
    // MARK: - UICollectionView Methods
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesCell.reuseID, for: indexPath) as! ImagesCell
       let unsplashImage = images[indexPath.item]
        cell.unsplashImage = unsplashImage
        return cell
    }
    
}

// MARK: - UISearchBarDelegate

extension ImagesCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.networkDataFetcher.fetchImages(searchTerm: searchText) { [weak self](searchResults) in
                guard let fetchedImages = searchResults else { return }
                self?.images = fetchedImages.results
                self?.collectionView.reloadData()
            }
        })
    }
}

