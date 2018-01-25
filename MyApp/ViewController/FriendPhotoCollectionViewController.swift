//
//  FriendPhotoCollectionViewController.swift
//  MyApp
//
//  Created by Ronin on 24/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import UIKit
import Alamofire

private let reuseIdentifier = FriendCollectionViewCell.reuseIdentifier

class FriendPhotoCollectionViewController: UICollectionViewController, AlertShower {
    
    var photos = [AlbumPhoto]() {
        didSet {
            collectionView?.reloadData()
        }
    }
    let clientVk = VKontakteAPI()
    var friend: User?
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNetworkData()
    }
    
    func loadNetworkData() {
        if let ownerId = friend?.id {
            clientVk.getPhotos(ownerId: ownerId) {[weak self] (photos, error) in
                if let photos = photos {
                    DispatchQueue.main.async {
                        self?.photos = photos
                    }                    
                } else {
                    self?.showError(title: "Failed to load photos", with: error?.localizedDescription)
                }
            }
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FriendCollectionViewCell
        
        guard let friendPhotoCell = cell else { return UICollectionViewCell() }
        let photo = photos[indexPath.row]
        friendPhotoCell.photo = photo
        
        return friendPhotoCell
    }
}
