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
                photosURLs.append(friend!.photoURL)
            }
        }        
    }
    var photosURLs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Need to have token
        /*let params = ["owner_id":friend?.uid,"access_token":Constants.VK.accessToken] as [String : Any]
        
        Alamofire.request(Constants.VK.urlPhotosAll, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON {[weak self] (response) in
            //print(response.result.value)
            if response.result.isSuccess {
                self?.photosURLs.removeAll()
                if let value = response.result.value {
                    let json = JSON(value)
                    if let result = json.dictionary {
                        if let result = result["response"]?.dictionary {
                            if let items = result["items"]?.array {
                                for item in items {
                                    self?.photosURLs.append(item["photo_130"].stringValue)
                                }
                                self?.collectionView?.reloadData()
                            }
                            
                            
                        } else if let errorJson = result["error"]?.dictionary {
                            print(errorJson)
                        }
                    }
                }
                
            } else {
                print(response.result.error)
            }
            
        }*/
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
                        if friendPhotoCell?.friend?.photoURL == response.request?.url?.absoluteString {
                            friendPhotoCell?.friendImageView?.image = image
                        }
                    }
                }
            }
        }
    
        return friendPhotoCell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
