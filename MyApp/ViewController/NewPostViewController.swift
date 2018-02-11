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

    @IBOutlet var textView: UITextView!
    @IBOutlet var mapView: MKMapView!
    let geoCoder = CLGeocoder()
    let clientVk = VKontakteAPI()
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapOnMap(sender:)))
        mapView.addGestureRecognizer(tapGesture)
    }
    @IBAction func postOnWall(_ sender: UIBarButtonItem) {
        clientVk.postOnWall(textView.text) {[weak self] (success, error) in
            if success {
                self?.resetUI()
                self?.showSuccessAlert()
            } else {
                self?.showError(with: error?.localizedDescription)
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

extension NewPostViewController: MKMapViewDelegate {
    
}
