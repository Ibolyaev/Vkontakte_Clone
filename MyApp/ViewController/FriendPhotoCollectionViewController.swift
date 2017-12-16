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

class FriendPhotoCollectionViewController: UICollectionViewController {
    
    var photos = [AlbumPhoto]()
    var friend: User?
    let VKClient = VKontakteAPI()
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNetworkData()
    }
    
    func loadNetworkData() {
        guard let token = AppState.shared.token, let ownerId = friend?.uid else { return }
        
        VKClient.getPhotos(token,ownerId: ownerId) {[weak self] (photos, error) in
            if let photos = photos {
                self?.photos = photos
                self?.collectionView?.reloadData()
            } else {
                print(error ?? "Failed to load data")
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
        
        Alamofire.request(photo.URL).responseData {[weak friendPhotoCell] (response) in
            if response.result.isSuccess {
                
                if let data = response.result.value,
                    let image = UIImage(data: data) {
                    if friendPhotoCell?.photo?.URL == response.request?.url {
                        friendPhotoCell?.friendImageView?.image = image
                    }
                }
            }
        }
        
        return friendPhotoCell
    }
}
