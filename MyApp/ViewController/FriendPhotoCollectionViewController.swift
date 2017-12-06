//
//  FriendPhotoCollectionViewController.swift
//  MyApp
//
//  Created by Ronin on 24/10/2017.
//  Copyright © 2017 Ronin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

private let reuseIdentifier = FriendCollectionViewCell.reuseIdentifier

class FriendPhotoCollectionViewController: UICollectionViewController {

    var friend: Friend? {
        didSet {
            if friend != nil {
                photosURLs.append(friend!.photo.url)
            }
        }        
    }
    var photosURLs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosURLs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FriendCollectionViewCell
        
        guard let friendPhotoCell = cell else { return UICollectionViewCell() }
        guard let friend = self.friend else { return UICollectionViewCell() }
        friendPhotoCell.friend = friend
        
        let photoURL = photosURLs[indexPath.row]
        
        Alamofire.request(photoURL).responseData {[weak friendPhotoCell] (response) in
            if response.result.isSuccess {
                
                if let data = response.result.value {
                    if let image = UIImage(data: data) {
                        if friendPhotoCell?.friend?.photo.url == response.request?.url?.absoluteString {
                            friendPhotoCell?.friendImageView?.image = image
                        }
                    }
                }
            }
        }
    
        return friendPhotoCell
    }
}
