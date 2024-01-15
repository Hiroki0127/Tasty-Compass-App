//
//  ListViewModel.swift
//  Tasty Compass
//


import Foundation
import Combine
import MapKit
import CoreLocation
//search term, user location, and the 3rd param is category when selected (optional)
final class ListViewModel: NSObject, ObservableObject {
    
    @Published var businesses = [Business]()
    @Published var searchText = ""
    @Published var userLatitude: Double = 0
    @Published var userLongitude: Double = 0
    private let locationManager = CLLocationManager()
    override init() {
    super.init()
    self.locationManager.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.startUpdatingLocation()
        }
    }
    extension ListViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else {return}
    userLatitude = location.coordinate.latitude
    userLongitude = location.coordinate.longitude
        }
    
    
    //String(location.coordinate.longitude)
    func search() {
        let live = YelpAPIService.live
        //location.coordinate.longitude
        
        live.search("food", .init(latitude: userLatitude, longitude: userLongitude), nil)
            .assign(to: &$businesses)
    }
    
}


