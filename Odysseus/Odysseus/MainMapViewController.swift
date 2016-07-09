//
//  FirstViewController.swift
//  Odysseus
//
//  Created by Zhengri Fan on 3/25/16.
//  Copyright © 2016 Zhengri Fan, Jiayu Huang. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation
/// This is the Map View in the first TabBar Screen
class MainMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITabBarControllerDelegate {
	/// diary-objects List
	var diarys = [Diary]()
	/// the Core data database instance
	var database = DatabaseCore()
	/// Location Manager Instance
	var locationManager = CLLocationManager()
	/// MapView Instance
	@IBOutlet weak var mapView: MKMapView!
	/**
	 Overload the viewdidload, load Location Manager, navigation bar color change and mapViewDelegate.
	 */
	override func viewDidLoad() {

		self.navigationController?.navigationBar.barStyle = .Black
		super.viewDidLoad()
		mapView.addAnnotations(getMapAnnotations())
		mapView.delegate = self
		tabBarController?.delegate = self
		var mapRegion = MKCoordinateRegion()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
		if (locationManager.location != nil) {
			mapRegion.center = (locationManager.location?.coordinate)!;
			mapRegion.span.latitudeDelta = 0.2;
			mapRegion.span.longitudeDelta = 0.2;

			mapView.setRegion(mapRegion, animated: true)
		}
		// Do any additional setup after loading the view, typically from a nib.
	}
	/**
	 This function is to sense the shake action
	 */
	override func canBecomeFirstResponder() -> Bool {
		return true
	}
	/**
	 If the shake ends, locate user's location
	 */
	override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
		if motion == .MotionShake {
			if (locationManager.location != nil) {
				var mapRegion = MKCoordinateRegion()
				mapRegion.center = (locationManager.location?.coordinate)!;
				mapRegion.span.latitudeDelta = 0.2;
				mapRegion.span.longitudeDelta = 0.2;
				mapView.setRegion(mapRegion, animated: true)
			}
		}
	}
	/**
	 This is an entry for cancel button pressed in note editing view
	 */
	@IBAction func cancel(segue: UIStoryboardSegue) {
	}

	/**
	 This is a function that can make switches from different tab bars without racing condition
	 */
	func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
		for i in tabBarController.viewControllers! {

			if i.isKindOfClass(UINavigationController) {
				if ((i as! UINavigationController).topViewController)!.isKindOfClass(NoteDetailController) {
					((i as! UINavigationController).topViewController as! NoteDetailController).dismissTheView()
				}
			}
			else if (i.isKindOfClass(UISplitViewController)) {
				if (i as! UISplitViewController).collapsed {
					let viewControllers = (i as! UISplitViewController).viewControllers
					for controller in viewControllers {
						(controller as! UINavigationController).popToRootViewControllerAnimated(true)
					}
				}
			}
		}
	}
	/**
	 Customize map annotations in this functon
	 */
	func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

		let reuseId = "DiaryPin"

		var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
		if pinView == nil {
			pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			pinView?.canShowCallout = true

			let rightButton = UIButton()
			rightButton.setTitle("➔", forState: UIControlState.Normal)
			rightButton.setTitleColor(UIColor(red: 255 / 255, green: 81 / 255, blue: 70 / 255, alpha: 1.0), forState: UIControlState.Normal)
			rightButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
			rightButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)

			rightButton.titleForState(UIControlState.Normal)
			pinView!.rightCalloutAccessoryView = rightButton as UIView
		}
		else {
			pinView?.annotation = annotation
		}

		return pinView
	}

	/**
	 When annotations pressed, call this function to send segue
	 */
	func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		if control == view.rightCalloutAccessoryView {
			performSegueWithIdentifier("toDiary", sender: view)
		}
	}
	/**
	 Sague Path for annotation pressed
	 */
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == "toDiary")
		{
			let noteViewController = segue.destinationViewController as! NoteDetailController
			noteViewController.diary = ((sender as! MKAnnotationView).annotation) as? Diary
		}
	}

	/**
	 Do some reset for view will appear
	 */
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(true)
		mapView.removeAnnotations(diarys)
		loadData()
		mapView.addAnnotations(getMapAnnotations())
	}

	/**
	 Entry for add button pressed in note editing view
	 */
	@IBAction func addDiary(segue: UIStoryboardSegue) {
		let detailController = segue.sourceViewController as! NewNoteViewController
		if (!detailController.brandNew) {
			saveDiary(detailController.diary!, brandNew: detailController.brandNew)
		} else {
			saveDiary(detailController.diary!, brandNew: detailController.brandNew)
		}
		dismissViewControllerAnimated(true, completion: nil)
	}

	/**
	 load the data from the database instance
	 */
	func loadData() {
		database.loadData()
		diarys = database.diaryArray
	}

	/**
	 load the mapAnnotations to a list
	 */
	func getMapAnnotations() -> [Diary] {
		var annotations: Array = [Diary]()
		self.loadData()
		// iterate and create annotations
		for item in self.diarys {
			annotations.append(item)
		}
		return annotations
	}
	/**
	 Save the diary entry
	 */
	func saveDiary(diaryObject: Diary, brandNew: Bool) {
		database.saveDiary(diaryObject, brandNew: brandNew)
	}
	/**
	 Warning override
	 */
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
