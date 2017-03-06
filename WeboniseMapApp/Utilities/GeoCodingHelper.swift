//
//  GeoCodingHelper.swift
//  WeboniseMapApp
//
//  Created by Pradeep Singh on 05/03/17.
//  Copyright © 2017 Pradeep Singh. All rights reserved.
//

import Foundation

import GoogleMaps

protocol GeoCodingDelegate {
    func geocodedLocation(_ location: CLLocationCoordinate2D, viewport: ViewPort, placeID : String)
    func didFailInGeocoding(_ error: GeocodingStatusCode)
}

struct ViewPort
{
    var northEast: CLLocationCoordinate2D?
    var southWest: CLLocationCoordinate2D?
}

class GeoCodingHelper {
    
    var delegate: GeoCodingDelegate?
    
    
    func geocodeAddress(_ address: String) {
        
        // Construct Geocode URL
        var geocodeURLString = baseURLGeocode + "address=" + address + "&key=" + googleGeoCodingAPIKey
        geocodeURLString = geocodeURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let geocodeURL = URL(string: geocodeURLString)
        
        if AppUtilities.isNetworkAvailable() {
            // Geocode Address
            DispatchQueue.main.async(execute: { () -> Void in
                
                let geocodingResultsData = try? Data(contentsOf: geocodeURL!)
                
                let dictionary : Dictionary = (try! JSONSerialization.jsonObject(with: geocodingResultsData!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary <String,Any>)
                
                // Get the response status.
                if let statusValue = dictionary["status"] {
                    
                    let status = statusValue as! String
                    
                    switch (status) {
                    case GeocodingStatusCode.OK.rawValue :
                        
                        if let resultsObject = dictionary["results"] {
                            
                            let allResults = resultsObject as! Array<Dictionary<AnyHashable, Any>>
                            
                            var addressDetails = allResults[0]
                            
                            if let geometryDictionary = addressDetails["geometry"] {
                                let geometry = geometryDictionary as! Dictionary<AnyHashable, Any>
                                
                                var coordinates : CLLocationCoordinate2D?
                                var viewPort : ViewPort?
                                var placeIDString : String?
                                
                                // Get Coordinates
                                if let locationValue = geometry["location"] {
                                    let locationDictionary = locationValue as! Dictionary<AnyHashable, Any>
                                    coordinates = self.getCLLocationCoordinate2DFromDictionary(dictionary: locationDictionary)
                                }
                                
                                if let viewPortValue = geometry["viewport"] {
                                    let viewPortDictionary = viewPortValue as! Dictionary<AnyHashable, Any>
                                    
                                    let northEastCoordinates = self.getCLLocationCoordinate2DFromViewPortDictionary(dictionary: viewPortDictionary, key: "northeast")
                                    
                                    let southWestCoordinates = self.getCLLocationCoordinate2DFromViewPortDictionary(dictionary: viewPortDictionary, key: "southwest")
                                    
                                    if CLLocationCoordinate2DIsValid(northEastCoordinates) && CLLocationCoordinate2DIsValid(southWestCoordinates){
                                        viewPort = ViewPort(northEast: northEastCoordinates, southWest: southWestCoordinates)
                                    }
                                }
                                
                                // get placeID
                                if let placeIDValue = addressDetails["place_id"]{
                                    placeIDString = placeIDValue as? String
                                }
                                
                                if CLLocationCoordinate2DIsValid(coordinates!) && (viewPort != nil){
                                    self.delegate?.geocodedLocation(coordinates!, viewport: viewPort!, placeID: placeIDString!)
                                }
                            }
                        }
                        
                        break
                    case GeocodingStatusCode.ZERO_RESULTS.rawValue :
                        self.delegate?.didFailInGeocoding(GeocodingStatusCode.ZERO_RESULTS)
                        break
                    case GeocodingStatusCode.OVER_QUERY_LIMIT.rawValue :
                        self.delegate?.didFailInGeocoding(GeocodingStatusCode.OVER_QUERY_LIMIT)
                        break
                    case GeocodingStatusCode.REQUEST_DENIED.rawValue :
                        self.delegate?.didFailInGeocoding(GeocodingStatusCode.REQUEST_DENIED)
                        
                        break
                    case GeocodingStatusCode.INVALID_REQUEST.rawValue :
                        self.delegate?.didFailInGeocoding(GeocodingStatusCode.INVALID_REQUEST)
                        
                        break
                    case GeocodingStatusCode.UNKNOWN_ERROR.rawValue :
                        self.delegate?.didFailInGeocoding(GeocodingStatusCode.UNKNOWN_ERROR)
                        break
                    default : break
                    }
                    
                }
                else{
                    self.delegate?.didFailInGeocoding(GeocodingStatusCode.UNKNOWN_ERROR)
                }
            })
        }
    }
    
    func getCLLocationCoordinate2DFromDictionary(dictionary : Dictionary<AnyHashable, Any>) -> CLLocationCoordinate2D {
        // check if dictionary contains lat and long
        
        let allKeys = dictionary.keys
        
        if (allKeys.contains("lat") && allKeys.contains("lng")){
            
            let latitude = dictionary["lat"] as! Double
            let longitude = dictionary["lng"] as! Double
            
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        else{
            return kCLLocationCoordinate2DInvalid
        }
    }
    
    func getCLLocationCoordinate2DFromViewPortDictionary(dictionary: Dictionary<AnyHashable, Any>, key : String) -> CLLocationCoordinate2D {
        
        let allKeys = dictionary.keys
        
        if allKeys.contains(key) {
            let viewPortChildDictionary = dictionary[key] as! Dictionary<AnyHashable, Any>
            let coordinates = self.getCLLocationCoordinate2DFromDictionary(dictionary: viewPortChildDictionary)
            return coordinates
        }
        else{
            return kCLLocationCoordinate2DInvalid
        }
    }
}
