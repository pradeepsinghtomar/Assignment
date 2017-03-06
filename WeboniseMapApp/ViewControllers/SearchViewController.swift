//
//  ViewController.swift
//  WeboniseMapApp
//
//  Created by Pradeep Singh on 05/03/17.
//  Copyright © 2017 Pradeep Singh. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var placesTableView: UITableView!    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let searchAutoCompleteHelper = SearchAutoCompleteHelper()
    
    internal var searchHistoryHelper = SearchHistoryHelper()
    internal var autoCompleteResultArray = [String]()
    internal var historyPlaces = [String]()
    internal var selectedPlaceName : String?
    
    private var isFirstExecution = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isFirstExecution {
            getHistoryData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        isFirstExecution = false
        
        // resign first responder
        searchBar.resignFirstResponder()
    }
    
    func getHistoryData() {
        searchHistoryHelper.getSearchHistory { [weak self] (placesArray, isHistoryAvailabe) in
            if isHistoryAvailabe {
                
                DispatchQueue.main.async {
                    self?.historyPlaces = placesArray!
                    self?.placesTableView.reloadData()
                }
            }
        }
    }
    
    func getLocationPredictionWithSearchText( text : String) {
        
        if AppUtilities.isNetworkAvailable() {
            searchAutoCompleteHelper.placeAutocomplete(text) { [weak self] (placesArray, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        AppUtilities.showErrorMessageForNetworkDrop(self!)
                    }
                }
                else if (placesArray?.count)! > 0 {
                    // set the data source of the tableview and reload it
                    DispatchQueue.main.async {
                        self?.autoCompleteResultArray = placesArray!
                        self?.placesTableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.MapViewControllerSegueIdentifier.rawValue {
            let destinationVC = segue.destination as! MapViewController
            destinationVC.selectedPlaceName = selectedPlaceName
        }
    }
}
