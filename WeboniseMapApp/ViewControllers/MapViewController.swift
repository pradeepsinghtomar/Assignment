//
//  MapViewController.swift
//  WeboniseMapApp
//
//  Created by Pradeep Singh on 05/03/17.
//  Copyright © 2017 Pradeep Singh. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var imageCollection: UICollectionView!
    
    internal var locationPhotoMetadaArray = [GMSPlacePhotoMetadata]()
    internal var isMarkerAdded : Bool = false
    var selectedPlaceName : String?
    
    private let geoCodingHelper = GeoCodingHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppUtilities.isNetworkAvailable() {
            geoCodingHelper.delegate = self
            geoCodingHelper.geocodeAddress(selectedPlaceName!)
        }
    }

    func updateMapView(_ location: CLLocationCoordinate2D, viewport: ViewPort, placeID : String) {

        DispatchQueue.main.async {
            
            // Move Map to that location
            self.mapView.animate(to: GMSCameraPosition(target: location, zoom: 5, bearing: 0, viewingAngle: 0))
            // Set Map ViewPort to show location properly
            let newBounds = GMSCoordinateBounds(coordinate: viewport.northEast!, coordinate: viewport.southWest!)
            self.mapView.animate(with: GMSCameraUpdate.fit(newBounds))

        }
        
        // invoke method to get the images for this location.
        self.getPhotosForLocation(with: placeID)
    }
    
    func addMarker(with location: CLLocationCoordinate2D) {
        // create a marker and add on the map
        let position = location
        let marker = GMSMarker()
        marker.position = position
        marker.title = selectedPlaceName
        marker.map = self.mapView!
        marker.appearAnimation = GMSMarkerAnimation.pop
    }
    
    
    func getPhotosForLocation(with placeID: String) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { [weak self] (photos, error) -> Void in
            if error != nil {
                DispatchQueue.main.async {
                    AppUtilities.showErrorMessageForNetworkDrop(self!)
                }
            } else {
                
                if let photosArray = photos {
                    
                    self?.locationPhotoMetadaArray = photosArray.results
                    
                    DispatchQueue.main.async {
                        self?.imageCollection.reloadData()
                    }
                }
            }
        }
    }
}
