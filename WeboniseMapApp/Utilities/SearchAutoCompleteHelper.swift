//
//  SearchAutoCompleteHelper.swift
//  WeboniseMapApp
//
//  Created by Pradeep Singh on 05/03/17.
//  Copyright © 2017 Pradeep Singh. All rights reserved.
//

import Foundation
import GooglePlaces

typealias SearchAutoCompleteHelperCompletionHandler = ([String]?, Error?) -> Swift.Void

class SearchAutoCompleteHelper {
    
    lazy var placesClient : GMSPlacesClient = GMSPlacesClient.shared()
    
    func placeAutocomplete(_ text: String, completionHandler: @escaping SearchAutoCompleteHelperCompletionHandler ) {
        
        let filter = GMSAutocompleteFilter()
        filter.type = GMSPlacesAutocompleteTypeFilter.geocode
        placesClient.autocompleteQuery(text, bounds: nil, filter: filter) { (result, error) in

            if let error = error {
                completionHandler(nil, error)
            }
            else{
                if let result = result {
                    
                    // create a String array
                    var placesArray = [String]()
                    
                    for placeRecord in result {
                        placesArray.append(placeRecord.attributedFullText.string)
                    }
                    
                    // send the string array to the requestor.
                    completionHandler(placesArray, nil)
                }
            }
        }
    }
}
