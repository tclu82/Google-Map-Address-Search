//
//  ViewController.swift
//  Google Map Address Search
//
//  Created by Zac on 1/16/17.
//  Copyright © 2017 Zac. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

// Inheritant CLLocationManagerDelegate, GMSMapViewDelegate
class ViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate {
    // outlets
    @IBOutlet private var googleMapsView: GMSMapView!
    // properties
    private var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//        locationManager.startMonitoringSignificantLocationChanges()
        
        initGoogleMaps()
    }
    
    /// Initialize Google Map
    private func initGoogleMaps()
    {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 25.0330, longitude: 121.5654, zoom: 6.0)
        
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        mapView.isMyLocationEnabled = true
        self.googleMapsView.camera = camera
        self.googleMapsView.delegate = self
        self.googleMapsView.isMyLocationEnabled = true
        self.googleMapsView.settings.myLocationButton = true
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        
        marker.position = CLLocationCoordinate2D(latitude: 25.0330, longitude: 121.5654)
        marker.title = "Taipei"
        marker.snippet = "Taiwan"
        marker.map = mapView
    }
    
    /// Cllocation Manager Delegate
    ///
    /// - Parameters:
    ///   - manager: <#manager description#>
    ///   - error: <#error description#>
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error while get location: \(error)")
    }
    
    /// Cllocation Manager Delegate
    ///
    /// - Parameters:
    ///   - manager: <#manager description#>
    ///   - locations: <#locations description#>
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location  = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        
        self.googleMapsView.animate(to: camera)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    /// Cllocation Manager Delegate
    ///
    /// - Parameters:
    ///   - mapView: GMSMapView
    ///   - position: GMSCameraPosition
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition)
    {
        self.googleMapsView.isMyLocationEnabled = true
    }
    
    /// Cllocation Manager Delegate
    ///
    /// - Parameters:
    ///   - mapView: GMSMapView
    ///   - gesture: Bool
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool)
    {
        self.googleMapsView.isMyLocationEnabled = true
        
        if gesture
        {
            mapView.selectedMarker = nil
        }
    }
    
    /// GMSAutocompleteViewControllerDelegate
    ///
    /// - Parameters:
    ///   - viewController: <#viewController description#>
    ///   - place: <#place description#>
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace)
    {
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 20.0)
        
        self.googleMapsView.camera = camera
        // dismiss after selecting place
        self.dismiss(animated: true, completion: nil)
    }
    
    /// GMSAutocompleteViewControllerDelegate
    ///
    /// - Parameters:
    ///   - viewController: GMSAutocompleteViewController
    ///   - error: Error
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error)
    {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    /// GMSAutocompleteViewControllerDelegate
    ///
    /// - Parameter viewController: GMSAutocompleteViewController
    func wasCancelled(_ viewController: GMSAutocompleteViewController)
    {   // User canceled the operation.
        dismiss(animated: true, completion: nil)
    }
    
    /// Search address
    ///
    /// - Parameter sender: UIBarButtonItem
    @IBAction private func searchAddress(_ sender: UIBarButtonItem)
    {
        let autoCompleteController = GMSAutocompleteViewController()
        
        autoCompleteController.delegate = self
        
        self.locationManager.startUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
