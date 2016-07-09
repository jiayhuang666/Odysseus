//
//  Diary.swift
//  Odysseus
//
//  Created by HuangJiayu on 3/28/16.
//  Copyright © 2016 Zhengri Fan, Jiayu Huang. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData
import MapKit
/// DiaryObject that can be managed in the program
class Diary: NSObject, MKAnnotation {
	var title: String?
	var subtitle: String?
	var text: String?
	var location: CLLocation?
	var time: Double?
	var images = [UIImage]()
	/**
	 Default initializer
	 */
	override init() {
		title = ""
		text = ""
		location = CLLocation()
		time = 0
	}
	/// Return its coordinate, to conform MKAnnotation
	var coordinate: CLLocationCoordinate2D {
		return (location?.coordinate)!
	}
	/**
	 conform MKAnnotation

	 - parameter latitude:  latitude double
	 - parameter longitude: longitude double

	 - returns: an Diary Object
	 */
	init(latitude: Double, longitude: Double) {
		self.location = CLLocation(latitude: latitude, longitude: longitude)
	}
	/**
	 A more complete initializer, just in case
	 */
	init(title: String, text: String, location: CLLocation, time: Double) {
		self.title = title
		self.subtitle = ""
		self.text = text
		self.location = location
		self.time = time
	}
	/**
	 Initialize a diary object with a coredata instance(NSManagedObject instance)

	 - parameter dataStored: NSManagedObject

	 - returns: Diary Object
	 */
	init(dataStored: NSManagedObject) {
		self.title = dataStored.valueForKey("title") as? String
		self.subtitle = ""
		self.text = dataStored.valueForKey("text") as? String
		let altitude = dataStored.valueForKey("altitude") as! Double
		let longitude = dataStored.valueForKey("longitude") as! Double
		let latitude = dataStored.valueForKey("latitude") as! Double
		if let image1 = dataStored.valueForKey("image1") as? NSData {
			self.images.append(UIImage(data: image1)!)
		}
		if let image2 = dataStored.valueForKey("image2") as? NSData {
			self.images.append(UIImage(data: image2)!)
		}

		if let image3 = dataStored.valueForKey("image3") as? NSData {
			self.images.append(UIImage(data: image3)!)
		}

		if let image4 = dataStored.valueForKey("image4") as? NSData {
			self.images.append(UIImage(data: image4)!)
		}

		self.location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), altitude: CLLocationDistance(altitude), horizontalAccuracy: 10.0, verticalAccuracy: 10.0, timestamp: NSDate(timeIntervalSince1970: 100))
		self.time = dataStored.valueForKey("time") as? Double
	}
}