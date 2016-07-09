//
//  SecondViewController.swift
//  Odysseus
//
//  Created by Zhengri Fan on 3/25/16.
//  Copyright © 2016 Zhengri Fan, Jiayu Huang. All rights reserved.
//

import UIKit
import CoreData
/// The Table View that present the Diary in time to Author
class MainTableViewController: UITableViewController, UISplitViewControllerDelegate {
	/// diary objects entry
	var diarys = [Diary]()
	/// if the splitview is collapsed or not
	var collapsed = true
	/// CoreDatabase instance
	var database = DatabaseCore()
	/**
	 In this method, we have refresh Control added
	 */
	override func viewDidLoad() {
		self.navigationController?.navigationBar.barStyle = .Black
		super.viewDidLoad()
		self.refreshControl?.addTarget(self, action: #selector(MainTableViewController.refreshData), forControlEvents: UIControlEvents.ValueChanged)
		splitViewController!.delegate = self
		// Do any additional setup after loading the view, typically from a nib.
	}
	/**
	 In this method, we refresh the data in the Table View
	 */
	@objc func refreshData() {
		loadData()
		self.tableView.reloadData()
		refreshControl?.endRefreshing()
	}
	/**
	 this can return the right status bar color
	 */
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return UIStatusBarStyle.LightContent
	}

	/**
	 Save a diary object to coreData

	 - parameter diaryObject: diaryObject
	 */
	func saveDiary(diaryObject: Diary, brandNew: Bool) {
		database.saveDiary(diaryObject, brandNew: brandNew)
	}

	/**
	 When Press Done, It will send segue here
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
	 To make the View consistancy
	 */
	override func viewWillAppear(animated: Bool) {

		(self.splitViewController?.viewControllers.first as! UINavigationController).navigationBar.barStyle = .Black
		super.viewWillAppear(true)

		loadData()
		self.tableView.reloadData()
	}
	/**
	 If press cancel in editing note, sague here
	 */
	@IBAction func cancel(segue: UIStoryboardSegue) {
	}
	/**
	 Override system function
	 */
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	/**
	 Return the size of the table
	 */
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return diarys.count
	}
	/**
	 return the correct cell for the table to present
	 */
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("Diary")
		cell?.textLabel!.text = diarys[indexPath.row].title
		return cell!
	}

	/**
	 Load data from the coreData
	 */
	func loadData() {
		database.loadData()
		diarys = database.diaryArray
	}

	/**
	 This enables the delete for the table
	 */
	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}

	/**
	 This implement data deletion entry
	 */
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if (editingStyle == UITableViewCellEditingStyle.Delete) {
			deleteData(indexPath)
			loadData()
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
		}
	}

	/**
	 If the cell is selected/clicked, call this function, then a detailview will be shown
	 */
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
//		let noteDetailController = storyboard.instantiateViewControllerWithIdentifier("noteDetailController") as! NoteDetailController
		let noteDetailNavigationController = storyboard.instantiateViewControllerWithIdentifier("noteDetailNavigationController") as! UINavigationController
		let noteDetailController = noteDetailNavigationController.topViewController as! NoteDetailController
		noteDetailController.diary = self.diarys[indexPath.row]
		// noteDetailController.index = indexPath.row
		showDetailViewController(noteDetailNavigationController, sender: self)
		collapsed = false
	}
	/**
	 Delete data when deleting the table cell
	 */
	func deleteData(indexPath: NSIndexPath) {
		database.deleteData(self.diarys[indexPath.row])
	}

	/**
	 Implement the collapse and expand of the splitView Controller
	 */
	func splitViewController(splitViewController: UISplitViewController,
		collapseSecondaryViewController secondaryViewController: UIViewController,
		ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
			return collapsed
	}
}
