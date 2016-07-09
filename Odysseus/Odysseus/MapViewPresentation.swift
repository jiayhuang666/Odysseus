//
//  MapViewPresentation.swift
//  Odysseus
//
//  Created by HuangJiayu on 4/11/16.
//  Copyright © 2016 Zhengri Fan, Jiayu Huang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
/// A sub-page that display the Location of the diary
class MapViewPresentation: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
	@IBOutlet weak var mapView: MKMapView!
	var longitude: Double?
	var latitude: Double?
	override func viewDidLoad() {
		mapView.delegate = self
		super.viewDidLoad()
		var mapRegion = MKCoordinateRegion()
		mapRegion.center = CLLocation(latitude: latitude!, longitude: longitude!).coordinate
		mapRegion.span.latitudeDelta = 0.2;
		mapRegion.span.longitudeDelta = 0.2;
		mapView.setRegion(mapRegion, animated: true)
		let dropPin = MKPointAnnotation()
		dropPin.coordinate = mapRegion.center
		mapView.addAnnotation(dropPin)
	}
}
