//
//  MapViewController+Delegates.swift
//  WeboniseMapApp
//
//  Created by Pradeep Singh on 05/03/17.
//  Copyright © 2017 Pradeep Singh. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation


extension MapViewController : GeoCodingDelegate {
    
    func geocodedLocation(_ location: CLLocationCoordinate2D, viewport: ViewPort, placeID : String) {
        self.updateMapView(location, viewport: viewport, placeID: placeID)
    }
    
    func didFailInGeocoding(_ error: GeocodingStatusCode){
        AppUtilities.showAlert("Error", message: "Unable to geocode the location.", okBtnTitle: "Okay", okHandler: { (alertAction: UIAlertAction!) in
        }, presenter: self)
    }
}

extension MapViewController : GMSMapViewDelegate {
    
    func mapViewSnapshotReady(_ mapView: GMSMapView) {
        
        if !isMarkerAdded {
            isMarkerAdded = true
            self.addMarker(with:self.mapView.camera.target)
        }
    }
}

extension MapViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locationPhotoMetadaArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.ImageCollectionViewCellIdentifier.rawValue, for: indexPath) as! ImageCollectionViewCell
        
        let photoMetaData = locationPhotoMetadaArray[indexPath.row]
        cell.locationImageView.loadImage(with: photoMetaData) { (error) in
            if error != nil {
                DispatchQueue.main.async {
                    AppUtilities.showAlert("Error", message: "Unable to load image for the location.", okBtnTitle: "Okay", okHandler: { (alertAction: UIAlertAction!) in
                    }, presenter: self)
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        let imageView = selectedCell.locationImageView
        
        if imageView?.image != nil {
            
            let imageToBeSaved = imageView?.image
            
            AppUtilities.showAlert_YES_NO_Style("Do you want to save the image?", message: "", yesBtnTitle: "Save", yesHandler: { (alertAction: UIAlertAction!) in
                
                ImageDownloader.download(image: imageToBeSaved!, failureCompletionHandler: { (isFailure) in
                    
                    if isFailure {
                        DispatchQueue.main.async {
                            AppUtilities.showAlert("Error", message: "Unable to save the image.", okBtnTitle: "Okay", okHandler: { (alertAction: UIAlertAction!) in
                            }, presenter: self)
                        }
                    }
                })
                
            }, noBtnTitle: "Cancel", noHandler: { (alertAction: UIAlertAction!) in
            }, presenter: self)
        }
    }
}
