//
//  GeotificationViewController.swift
//  TrialCouponedIt!! 5
//
//  Created by Apoorva Moodbidri on 3/21/17.
//  Copyright © 2017 Apoorva Moodbidri. All rights reserved.
//

import UIKit
import MapKit
import UserNotifications
import CoreLocation

protocol HandleMapSearch {
    func dropPinZoomIn(_ placemark:MKPlacemark)
}

protocol SaveLocation {
    func saveLocation(locationName:String)
}


class GeotificationViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate,UISearchBarDelegate,UITextFieldDelegate{

    @IBOutlet weak var mapView: MKMapView!
   
    
    @IBOutlet weak var messageTextField: UITextField!
  
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
   
    
    
    
    var locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    var pins:[MKMapItem] = []
    var identifier:String = UUID().uuidString
    var delegate:SaveLocation? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Seek permission to access users location
        
        let authorisationstatus = CLLocationManager.authorizationStatus()
        switch authorisationstatus
        {
                case .denied :
            let alert = UIAlertController(title: "Alert", message: "Please enable the Location", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
           
            
               case .notDetermined :
            locationManager.requestAlwaysAuthorization()
            
               case .authorizedAlways :
            locationManager.startUpdatingLocation()
            
        default:
            break
        }
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters//min dist after which the device requests for an update of the users location 
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow //Setting the tracking mode to follow or followWithHeading causes the map view to center the map on that location and begin tracking the user’s location. If the map is zoomed out, the map view automatically zooms in on the user’s location, effectively changing the current visible region.
        
        //searchTable
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        //set up the search bar 
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search For Places"
        navigationItem.titleView = resultSearchController?.searchBar//adds it to the title portion of the navigationItem 
        
        //configure the UISearchController appearance 
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true //A Boolean value that indicates whether this view controller's view is covered when the view controller or one of its descendants presents a view controller.
       
        locationSearchTable.mapView = mapView
        //This passes along a handle of the mapView from the Geo View Controller onto the locationSearchTable
        
        locationSearchTable.handleMapSearchDelegate = self
        
       
        //keyboard function
        messageTextField.delegate = self
        //messageTextField.addTarget(self, action: #selector(editTextField(_:)), for: .editingChanged)
        //messageTextField.addTarget(self, action: #selector(editTextField(_:)), for: .editingChanged)
    }
    
//    func editTextField(_ textField:UITextField) {
//        if textField.text?.characters.count == 1 {
//            if textField.text?.characters.first == " " {
//                 textField.text = ""
//                return
//            }
//        }
//        guard let message = messageTextField.text, !message.isEmpty
//            else {
//                saveButton.isEnabled = false
//                return
//        }
//        saveButton.isEnabled = true
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTextField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span  = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: false)
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
           
            //creates and initialises a new pin with the id we provide
            pinView?.pinTintColor = UIColor.purple
            pinView?.canShowCallout = true
            //A boolean value indicating whether the annotation view is able to display extra information in a callout bubble
            
            let smallSquare = CGSize(width:30, height:30)
            let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            pinView!.leftCalloutAccessoryView = button
            
        }
        else
        {
            pinView!.annotation = annotation
        }
        return pinView
    }
    //MARK : Actions
    
   
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        delegate?.saveLocation(locationName: (selectedPin?.name)!)
        scheduleNotification(location: selectedPin!)
        _ = navigationController?.popViewController(animated: true)
    }
    
  
    @IBAction func cancelButtonTapped(_ sender: Any) {
      
        _ = navigationController?.popViewController(animated: true)
        
    }
    
 //Handling the region 

    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
      
        locationManager.startMonitoring(for: region)
    }
    
    func scheduleNotification(location:MKPlacemark){
              let center = location.coordinate
        print(" please be right \(location.name!)")
              let region = CLCircularRegion.init(center: center, radius: 50.0, identifier: identifier)
              region.notifyOnExit = false
              region.notifyOnEntry = true
              let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
               print("pls : \(region)")
            
            let content  = UNMutableNotificationContent()
            content.title = "Notification"
            content.body = messageTextField.text!
            
            let request = UNNotificationRequest(identifier: (selectedPin?.name!)!, content: content, trigger: trigger)
        
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                if (error != nil)
                {
                    print("Failed : \(error.debugDescription)")
                }
            })
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


extension GeotificationViewController:HandleMapSearch {
    internal func dropPinZoomIn(_ placemark: MKPlacemark) {
        //Store the selected placemark
        selectedPin = placemark
       
        //clear the exsisting pins
        mapView.removeAnnotations(mapView.annotations)
       
        //create an annotation for the selected pin
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality, //
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: false)
    }

}
