//
//  NewPostViewController.swift
//  MyApp
//
//  Created by Игорь Боляев on 11.02.2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import UIKit
import MapKit

class NewPostViewController: UIViewController, AlertShower {

    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var mapView: MKMapView!
    let geoCoder = CLGeocoder()
    let clientVk = VKontakteAPI()
    private let imagePicker = UIImagePickerController()
    private var currentPlacemark: CLPlacemark?
    private var selectedPlacemark: CLPlacemark? {
        didSet {
            if let currentPlace = currentPlacemark, let name = currentPlace.name {
                textView?.text = textView?.text.replacingOccurrences(of: name, with: "")
            }
            currentPlacemark = selectedPlacemark
            updatePostText(with: selectedPlacemark)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mapTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapOnMap(sender:)))
        mapView.addGestureRecognizer(mapTapGesture)
        
        let photoTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.addNewPhoto(sender:)))
        postImageView.addGestureRecognizer(photoTapGesture)
        imagePicker.delegate = self
    }
    
    @objc func addNewPhoto(sender: UITapGestureRecognizer) {
        
        let actionView = UIAlertController(title: "Pick photo", message: nil, preferredStyle: .actionSheet)
        actionView.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {[weak self] (action) in
            self?.choosePhoto(type: .photoLibrary)
        }))
        actionView.addAction(UIAlertAction(title: "Camera", style: .default, handler: {[weak self] (action) in
            self?.choosePhoto(type: .camera)
        }))
        actionView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            // show gallery
        }))
        
        present(actionView, animated: true, completion: nil)
        
    }
    
    func choosePhoto(type: UIImagePickerControllerSourceType) {
        imagePicker.sourceType = type
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func postOnWall(_ sender: UIBarButtonItem) {
        let postText = textView.text
        guard let image = postImageView.image else { return }
        clientVk.uploadPhoto(image) {[weak self] (photo, error) in
            var attachment: NewsPhoto?
            if let photo = photo {
                attachment = photo
            } else {
                DispatchQueue.main.async {
                    self?.showError(with: error?.localizedDescription)
                }
            }
            // Upload post with or without attachment
            self?.clientVk.postOnWall(postText ?? "", attachment: attachment) {[weak self] (success, error) in
                DispatchQueue.main.async {
                    if success {
                        self?.resetUI()
                        self?.showSuccessAlert()
                    } else {
                        self?.showError(with: error?.localizedDescription)
                    }
                }
            }
        }
        
    }
    @objc func didTapOnMap(sender: UITapGestureRecognizer) {
        let point = sender.location(in: mapView)
        let coordinant = mapView.convert(point, toCoordinateFrom: mapView)
        let location = CLLocation(latitude: coordinant.latitude, longitude: coordinant.longitude)
        geoCoder.reverseGeocodeLocation(location) { (placeMark, error) in
            guard let placeMark = placeMark?.first else { return }
            self.selectedPlacemark = placeMark
        }
    }
    func resetUI() {
        textView.text = ""
        postImageView.image = UIImage(named: "Vk")
    }
    func showSuccessAlert() {
        let alert = UIAlertController(title: "New post added successfully", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func updatePostText(with placemark: CLPlacemark?) {
        guard let textView = textView, let placemark = placemark else {
            return
        }
        textView.text? += placemark.name ?? ""
    }
}

extension NewPostViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            postImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
extension NewPostViewController: UINavigationControllerDelegate {
    
}
extension NewPostViewController: MKMapViewDelegate {
    
}
