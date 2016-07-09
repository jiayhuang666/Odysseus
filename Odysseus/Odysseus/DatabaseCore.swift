//
//  databaseCore.swift
//  Odysseus
//
//  Created by HuangJiayu on 3/31/16.
//  Copyright © 2016 Zhengri Fan, Jiayu Huang. All rights reserved.
//

import Foundation
import CoreData
import UIKit
/// The Coredata databse core instance/util
class DatabaseCore: NSObject {
	var diarys = [NSManagedObject]()
	var diaryArray = [Diary]()
	var diaryDict = [Diary: NSManagedObject]()
	let appDelegate =
		UIApplication.sharedApplication().delegate as! AppDelegate
	var managedContext: NSManagedObjectContext?
	/**
	 Default initializer

	 - returns: a database object
	 */
	override init() {
		super.init()
		loadData()
		managedContext = appDelegate.managedObjectContext
	}
	/**
	 load the diarys from the core data database
	 */
	func loadData() {
		diaryArray = [Diary]()
		managedContext = appDelegate.managedObjectContext
		let fetchRequest = NSFetchRequest(entityName: "Diary")
		do {
			let results =
				try managedContext!.executeFetchRequest(fetchRequest)
			diarys = results as! [NSManagedObject]
			for i in diarys {
				let tmpDiary = Diary(dataStored: i)
				diaryArray.append(tmpDiary)
				diaryDict[tmpDiary] = i
			}
			diaryArray.sortInPlace({ $0.time > $1.time })
		} catch let error as NSError {
			print("Could not fetch \(error), \(error.userInfo)")
		}
	}
	/**
	 Delete a diary from the core data databse

	 - parameter diary: Diary object
	 */
	func deleteData(diary: Diary) {
		managedContext = appDelegate.managedObjectContext
		let fetchRequest = NSFetchRequest(entityName: "Diary")
		do {
			try managedContext!.executeFetchRequest(fetchRequest)
			managedContext!.deleteObject(diaryDict[diary]!)
			try managedContext!.save()
		} catch let error as NSError {
			print("Could not delete \(error), \(error.userInfo)")
		}
	}
	/**
	 Save a diary to the core data object with a boolean argument if it is a new
	 entry or not

	 - parameter diaryObject: Diary object
	 - parameter brandNew:    if it is brand new diary or not
	 */
	func saveDiary(diaryObject: Diary, brandNew: Bool) {
		if (!brandNew) {
			self.deleteData(diaryObject)
		}
		managedContext = appDelegate.managedObjectContext
		let entity = NSEntityDescription.entityForName("Diary",
			inManagedObjectContext: managedContext!)
		let diary = NSManagedObject(entity: entity!,
			insertIntoManagedObjectContext: managedContext)
		diary.setValue((diaryObject.title)! as NSString, forKey: "title")
		diary.setValue((diaryObject.text)! as NSString, forKey: "text")
		diary.setValue(diaryObject.location!.altitude, forKey: "altitude")
		diary.setValue(diaryObject.location!.coordinate.latitude, forKey: "latitude")
		diary.setValue(diaryObject.location!.coordinate.longitude, forKey: "longitude")
		diary.setValue(diaryObject.time, forKey: "time")
		let imageNum = diaryObject.images.count
		if imageNum >= 1 {
			diary.setValue(UIImagePNGRepresentation(diaryObject.images[0]), forKey: "image1")
		}
		if imageNum >= 2 {
			diary.setValue(UIImagePNGRepresentation(diaryObject.images[1]), forKey: "image2")
		}
		if imageNum >= 3 {
			diary.setValue(UIImagePNGRepresentation(diaryObject.images[2]), forKey: "image3")
		}
		if imageNum >= 4 {
			diary.setValue(UIImagePNGRepresentation(diaryObject.images[3]), forKey: "image4")
		}
		do {
			try managedContext!.save()
		} catch let error as NSError {
			print("Could not save \(error), \(error.userInfo)")
		}
	}
}