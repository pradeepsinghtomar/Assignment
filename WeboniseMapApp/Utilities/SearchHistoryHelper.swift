//
//  SearchHistoryHelper.swift
//  WeboniseMapApp
//
//  Created by Pradeep Singh on 05/03/17.
//  Copyright © 2017 Pradeep Singh. All rights reserved.
//

import Foundation

typealias SearchHistoryCompletionHandler = ([String]?, Bool) -> Swift.Void

class SearchHistoryHelper {
    
    private let userDefaultHelper = UserDefaultHelper()
    private let historyKey = UserDefaultKey.HistoryKey.rawValue
    private var historyStringArray : [String]?
    
    var isHistoryAvailable : Bool = false

    init() {
        checkHistoryDataAvailability()
    }
    
    // get the places name list
    func getSearchHistory(with completionHandler: SearchHistoryCompletionHandler) {
        completionHandler(historyStringArray, isHistoryAvailable)
    }
    
    // add a new record
    func updateHistoryData(selectedPlace placeName : String) {
        
        if !isHistoryAvailable {
            // check if the array is initialised or not
            if historyStringArray == nil {
                historyStringArray = [String]()
            }
            addDataInHistory(placeName: placeName)
        }
        else {
            // check for duplicate first
            if !checkForDuplicate(newPlace: placeName) {
                addDataInHistory(placeName: placeName)
            }
        }
    }
    
    // check if history data is available
    private func checkHistoryDataAvailability() {
        
        isHistoryAvailable = userDefaultHelper.isKeyExists(historyKey)
        
        if isHistoryAvailable {
            // if it available, then fetch the history collection.
            let historyData = userDefaultHelper.getUserDefaultObject(historyKey)
            if historyData is [String] {
                historyStringArray = historyData as? [String]
            }
        }
    }
    
    // save the name in the list
    private func addDataInHistory( placeName : String) {
        
        // check the array size 
        if historyStringArray?.count == maxHistoryRecordCount {
            // delete the last object
            historyStringArray?.remove(at: (maxHistoryRecordCount-1))
        }
        
        // append the new one at [0]
        historyStringArray?.insert(placeName, at: 0)
        
        // save the array in the userdefault
        userDefaultHelper.saveUserDefault(historyKey, value: historyStringArray as Any)
    }
    
    // check for duplicate in data
    private func checkForDuplicate(newPlace placeName : String) -> Bool {
        return (historyStringArray?.contains(placeName))!
    }
    
}
