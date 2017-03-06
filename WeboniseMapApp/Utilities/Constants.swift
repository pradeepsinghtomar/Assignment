//
//  Constants.swift
//  WeboniseMapApp
//
//  Created by Pradeep Singh on 05/03/17.
//  Copyright © 2017 Pradeep Singh. All rights reserved.
//

import Foundation

// Segue Identifiers
enum SegueIdentifier : String {
    case MapViewControllerSegueIdentifier = "mapViewControllerSegueIdentifier"
}

// Cell Identifiers
enum CellIdentifier : String {
    case SearchCellIdentifier = "searchCellIdentifier"
    case ImageCollectionViewCellIdentifier = "imageCollectionViewCellIdentifier"
}

// TableView Header Titles
enum TableViewHeaderTitle : String {
    case HistoryHeaderTitle = "Recent Search"
    case SearchHeaderTitle = "Search Prediction"
}

// UserDefault Keys
enum UserDefaultKey : String {
    case HistoryKey = "historyKey"
}

// GeoCoding parsing error response
enum GeocodingStatusCode : String {
    case OK = "OK"
    case ZERO_RESULTS = "ZERO_RESULTS"
    case OVER_QUERY_LIMIT = "OVER_QUERY_LIMIT"
    case REQUEST_DENIED = "REQUEST_DENIED"
    case INVALID_REQUEST = "INVALID_REQUEST"
    case UNKNOWN_ERROR = "UNKNOWN_ERROR"
}

// Search History Contant
let maxHistoryRecordCount = 5

// Search header height
let tableViewHeaderHeight = 40.0

// File Save Constant
let imageNameLength = 8

// Google Map API Key
let googleMapAPIKey = "AIzaSyDTFEBT9M3khGIsoFoJq01IjwTI1D-IzWE"
let googleGeoCodingAPIKey = "AIzaSyCCbyx3oabfc9Qp1nGN9n61lr5IzwGnYNo"
let baseURLGeocode = "https://maps.googleapis.com/maps/api/geocode/json?"



