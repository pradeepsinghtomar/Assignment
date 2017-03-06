//
//  SearchViewController+Delegates.swift
//  WeboniseMapApp
//
//  Created by Pradeep Singh on 05/03/17.
//  Copyright © 2017 Pradeep Singh. All rights reserved.
//

import UIKit

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    
    // tableview delegates
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // update the history
        
        if historyPlaces.count > 0 {
            if indexPath.section == 1 {
                searchHistoryHelper.updateHistoryData(selectedPlace: autoCompleteResultArray[indexPath.row])
                // set the selected place value
                selectedPlaceName = autoCompleteResultArray[indexPath.row]
            }
            else{
                // set the selected place value
                selectedPlaceName = historyPlaces[indexPath.row]
            }
        }
        else{
            searchHistoryHelper.updateHistoryData(selectedPlace: autoCompleteResultArray[indexPath.row])
            // set the selected place value
            selectedPlaceName = autoCompleteResultArray[indexPath.row]
        }
        
        
        if selectedPlaceName?.isEmpty == false {
            // navigate to the map view.
            performSegue(withIdentifier: SegueIdentifier.MapViewControllerSegueIdentifier.rawValue, sender: self)
        }
    }
    
    // tableview datasources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // create number of rows accrodingly
        if historyPlaces.count > 0 {
            if section == 0 {
                return historyPlaces.count
            }
            else{
                return autoCompleteResultArray.count
            }
        }
        else{
            return autoCompleteResultArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.SearchCellIdentifier.rawValue)
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier:CellIdentifier.SearchCellIdentifier.rawValue)
        }
        
        if historyPlaces.count > 0 {
            if indexPath.section == 0 {
                cell!.textLabel?.text = historyPlaces[indexPath.row]
            }
            else{
                cell!.textLabel?.text = autoCompleteResultArray[indexPath.row]
            }
        }
        else{
            cell!.textLabel?.text = autoCompleteResultArray[indexPath.row]
        }
        
        return cell!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if historyPlaces.count > 0 {
            
            if autoCompleteResultArray.count == 0 {
                return 1
            }
            return 2
        }
        else{
            
            if autoCompleteResultArray.count == 0 {
                return 0
            }
            return 1
        }
    }
    
    // configure Headers of the sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchHistoryHelper.isHistoryAvailable {
            if section == 0 {
                return TableViewHeaderTitle.HistoryHeaderTitle.rawValue
            }
            else{
                return TableViewHeaderTitle.SearchHeaderTitle.rawValue
            }
        }
        else{
            return TableViewHeaderTitle.SearchHeaderTitle.rawValue
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(tableViewHeaderHeight)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.backgroundColor = UIColor.lightGray
    }
    
}

extension SearchViewController : UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.getHistoryData()
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == false {
            // perform the logic of fetching the records.
            getLocationPredictionWithSearchText(text: searchText)
        }
        else if searchText.isEmpty {
            autoCompleteResultArray = [String]()
            placesTableView.reloadData()
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        autoCompleteResultArray = [String]()
        historyPlaces = [String]()
        placesTableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty == false {
            getLocationPredictionWithSearchText(text: searchBar.text!)
            searchBar.resignFirstResponder()
        }
    }
}

