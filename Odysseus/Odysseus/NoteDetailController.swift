//
//  NoteDetailController.swift
//  Odysseus
//
//  Created by Zhengri Fan on 3/30/16.
//  Copyright © 2016 Zhengri Fan, Jiayu Huang. All rights reserved.
//

import UIKit

/// View controller that control the display of readonly view of diary
class NoteDetailController: UIViewController {

	@IBOutlet weak var editButton: UIBarButtonItem!
	var diary: Diary?
	var index: Int?
	/**
	 Initialize the view, set the navigationBar style
	 */
	override func viewDidLoad() {
		self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
		self.navigationController?.navigationBar.barStyle = .Black
		super.viewDidLoad()
		self.showDiary()
		navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
		navigationItem.leftItemsSupplementBackButton = true
		if (diary == nil) {
			editButton.enabled = false
			self.diary = Diary()
		}

		// Do any additional setup after loading the view.
	}
	/**
	 Implement the statusbar style
	 */
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}
	/**
	 General override
	 */
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	/*
	 // MARK: - Navigation

	 // In a storyboard-based application, you will often want to do a little preparation before navigation
	 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	 // Get the new view controller using segue.destinationViewController.
	 // Pass the selected object to the new view controller.
	 }
	 */
	/**
	 Show the diary from the title
	 */
	func showDiary() {
		guard diary != nil else {
			return
		}
		self.navigationItem.title = diary!.title
	}
	/**
	 Implement the viewWillDisappear
	 */
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(false)
	}

	/**
	 dismiss the View, handel some resource reallocation problem
	 */
	func dismissTheView() {
		super.viewWillDisappear(false)
		self.navigationController?.popToRootViewControllerAnimated(true)
		if self.splitViewController != nil && self.splitViewController!.collapsed {
			let viewControllers = self.splitViewController!.viewControllers
			for controller in viewControllers {
				(controller as! UINavigationController).popToRootViewControllerAnimated(true)
			}
		}
	}

	/**
	 Sague to a editing view when the edit button pressed
	 */
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "editTheExistedView" {
			let detailedViewController = (segue.destinationViewController as! UINavigationController).topViewController as! NewNoteViewController
			detailedViewController.brandNew = false
			detailedViewController.time = diary?.time
			detailedViewController.diary = diary
			detailedViewController.textEditing = (diary?.text)!
			detailedViewController.titleEditing = (diary?.title)!
			detailedViewController.index = self.index
			detailedViewController.title = diary!.title
			detailedViewController.images = (diary?.images)!
		}
		if segue.identifier == "embedNEWPages" {
			let detailedViewController = segue.destinationViewController as! PageViewPresentationer
			detailedViewController.diary = self.diary
		}
	}
}
