//
//  AboutPageController.swift
//  Odysseus
//
//  Created by Zhengri Fan on 4/27/16.
//  Copyright © 2016 Zhengri Fan, Jiayu Huang. All rights reserved.
//

import UIKit
/// The view class for the about page
class AboutPageController: UIViewController {

	/**
	 Change the navigation bar text color
	 */
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
		self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
	}

	/**
	 Go to settings page if user taps the setting icon

	 - parameter sender: the setting icon
	 */
	@IBAction func settingAction(sender: AnyObject) {
		let appSettings = NSURL(string: UIApplicationOpenSettingsURLString)
		UIApplication.sharedApplication().openURL(appSettings!)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
