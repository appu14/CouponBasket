//
//  LocationSearchTable.swift
//  TrialCouponedIt!! 5
//
//  Created by Apoorva Moodbidri on 3/21/17.
//  Copyright © 2017 Apoorva Moodbidri. All rights reserved.
//

import Foundation
import UIKit
import MapKit



class LocationSearchTable:UITableViewController {
    var matchingItems:[MKMapItem] = []
    var mapView:MKMapView? = nil
    //Search queries rely on a map region to prioritize local results. The mapView variable is a handle to the map from the previous screen
    var handleMapSearchDelegate:HandleMapSearch? = nil
    
    
    func parseAddress(_ selectedItem:MKPlacemark)-> String{
        
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : "" //put a space
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil ) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? "," : ""
        
        let secondSpace = (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            //name
            selectedItem.name ?? "",
            
            selectedItem.title ?? "",
            firstSpace,
            
            // street number
            // selectedItem.subThoroughfare ?? "",
            
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            
            // city
            selectedItem.locality ?? "",
            secondSpace,
            
            // state
            selectedItem.administrativeArea ?? ""   // to get the proper address format
        )
        
        return addressLine
    }
    //this is to make the address apppear in a presentable form like "262 Bush Street SanFrancisco"
    

    
}

extension LocationSearchTable :UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
            // guard unwraps optional values for mapView and searcText
            let searcBarText = searchController.searchBar.text else {return}
        
        //create a request for searching the places using normal english language
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searcBarText
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        //this performs the actual search on the request we just created above
        search.start { (response, error) in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}

//TableView data source for the LocationSearchTable
extension LocationSearchTable {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(selectedItem)
        dismiss(animated: true, completion: nil)
    }
    //when u select the row from the search results the dropping func is called
    
}
