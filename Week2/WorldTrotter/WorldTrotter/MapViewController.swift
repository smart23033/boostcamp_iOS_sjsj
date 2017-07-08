//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by 김성준 on 2017. 7. 7..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit
import MapKit

struct myLocation {
    var name: String
    var latitude: Double
    var longitude: Double
    
    init(name: String, lat latitude: Double, long longitude: Double){
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var mapView: MKMapView!
    var currentLocationButton: UIButton!
    var pinControlButton: UIButton!
    var myLocations: [myLocation] = []
    
    //keeps track of current pin index:
    var selectedAnnotationIndex: Int = -1
    
    override func loadView() {
        // 지도 뷰 생성
        mapView = MKMapView()
        mapView.delegate = self
        
        view = mapView
    
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(segControl:)), for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        currentLocationButton = UIButton(type: .custom)
        currentLocationButton.setImage(#imageLiteral(resourceName: "CurrentLocation"), for: .normal)
        
        currentLocationButton.addTarget(self, action: #selector(updateUserLocation), for: .touchUpInside)
        
        currentLocationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(currentLocationButton)
        
        let locationButtonTopConstraint = currentLocationButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20)
        let locationButtonTrailingConstraint = currentLocationButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -5)
        
        locationButtonTopConstraint.isActive = true
        locationButtonTrailingConstraint.isActive = true
        
        myLocations.append(myLocation(name: "Hometown", lat: 37.210407662727205, long: 127.11465741532114532114))
        myLocations.append(myLocation(name: "CurrentLocation", lat: 37.610407662727205, long: 127.01465741532114532114))
        myLocations.append(myLocation(name: "InterestingPlace", lat: 37.010407662727205, long: 127.05465741532114532114))
        
        for location in myLocations {
            let pin = MKPointAnnotation()
            pin.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
            pin.title = location.name
            mapView.addAnnotation(pin)
        }
        
        pinControlButton = UIButton(type: .infoLight)
        
        pinControlButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pinControlButton)
        
        pinControlButton.addTarget(self, action: #selector(showNextPin), for: .touchUpInside)
        
        let pinControlButtonTopConstraint = pinControlButton.topAnchor.constraint(equalTo: currentLocationButton.bottomAnchor, constant: 20)
        let pinControlButtonTrailingConstraint = pinControlButton.trailingAnchor.constraint(equalTo: currentLocationButton.trailingAnchor)
        
        pinControlButtonTopConstraint.isActive = true
        pinControlButtonTrailingConstraint.isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MapViewController loaded its view")
        
    }
    
    // MARK: Methods
    
    func mapTypeChanged(segControl: UISegmentedControl){
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    func updateUserLocation() {
        print("updateUserLocation is clicked")
        
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        mapView.showsUserLocation = true
    }
    
    func showNextPin() {
        
        //data checks:
        if !(mapView.annotations.count > 0) {
            return
        }
        
        //go to next annotation or back to start if last one:
        selectedAnnotationIndex += 1
        if selectedAnnotationIndex >= mapView.annotations.count {
            selectedAnnotationIndex = 0
        }
        
        let annotation = mapView.annotations[selectedAnnotationIndex]
        mapView.selectAnnotation(annotation, animated: true)
        let zoomedInCurrentLocation = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 5000, 5000)
        mapView.setRegion(zoomedInCurrentLocation, animated: true)
        
    }
    
    // MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("Log: did update user location")
        
        let currentLocation = mapView.userLocation.location
        
        if let currentLocation = currentLocation {
            let location = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            
            print("Log: currentLocation is \(location)")
            
            let span = MKCoordinateSpanMake(0.04, 0.04) // 1 degree ~ 0.0175 radian
            let region = MKCoordinateRegion(center: location, span: span)
            
            mapView.setRegion(region, animated: true)
        }
    
    }
    
}
