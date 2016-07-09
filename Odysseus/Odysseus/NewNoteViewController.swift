//
//  NewNoteViewController.swift
//  Odysseus
//
//  Created by HuangJiayu on 3/28/16.
//  Copyright © 2016 Zhengri Fan, Jiayu Huang. All rights reserved.
//

import UIKit
import CoreLocation
import Photos
// This is the View when user is adding a new note or editing an existing note
class NewNoteViewController: UIViewController, CLLocationManagerDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@IBOutlet weak var thumbnailFrame: UIView!
	@IBOutlet weak var diaryTitle: TextViewWithPlaceHolder!
	@IBOutlet weak var diaryText: TextViewWithPlaceHolder!
	// True for creating a new diary; False for editing existing one
	var brandNew = true
	var index: Int?
	// The system location
	let locationManager = CLLocationManager()
	// The ststem image picker for the user to choose images
	var imagepicker = UIImagePickerController()

	// thumbnail size would be a square with side length of this var
	let thumbnailSize: CGFloat?
	// var imaged: Bool = false
	// diary object to save or loading
	var diary: Diary?
	// Time for creating the note
	var time: Double?
	// The title and text when editing an existing note
	var titleEditing: String?
	var textEditing: String?
	// var tableCellCounter: Int = 0
	let addNewImageView = UIImageView(image: UIImage(named: "1461018903_photo512x512.png"))
	// Images that user added
	var images: [UIImage] = []
	var imageViews: [UIImageView] = []
	// Get the device info
	let device = Device()
	// Alert for deletion
	var comfirmDeletionAlert: UIAlertController?
	// Alert for no permission of photo
	var resourceUnavailableAlert: UIAlertController?

//    Initialize constants
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		let device = Device()
		let fourInchDevices: [Device] = [.iPhone5, .iPhone5c, .iPhone5s, .iPhoneSE, .Simulator(.iPhone5), .Simulator(.iPhone5c), .Simulator(.iPhone5s), .Simulator(.iPhoneSE)]
		let fiveInchDevices: [Device] = [.iPhone6, .iPhone6s, .Simulator(.iPhone6), .Simulator(.iPhone6s)]
		let fiveHalfInchDevices: [Device] = [.iPhone6Plus, .iPhone6sPlus, .Simulator(.iPhone6Plus), .Simulator(.iPhone6sPlus)]
		if device.isOneOf(fourInchDevices) {
			thumbnailSize = 60
		} else if device.isOneOf(fiveInchDevices) {
			thumbnailSize = 60
		} else if device.isOneOf(fiveHalfInchDevices) {
			thumbnailSize = 80
		} else if device.isPad {
			thumbnailSize = 76
		} else if device == .iPadPro || device == .Simulator(.iPadPro) {
			thumbnailSize = 84
		}
		else {
			thumbnailSize = 70
		}

		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	required init?(coder aDecoder: NSCoder) {
		let device = Device()
		let fourInchDevices: [Device] = [.iPhone5, .iPhone5c, .iPhone5s, .iPhoneSE, .Simulator(.iPhone5), .Simulator(.iPhone5c), .Simulator(.iPhone5s), .Simulator(.iPhoneSE)]
		let fiveInchDevices: [Device] = [.iPhone6, .iPhone6s, .Simulator(.iPhone6), .Simulator(.iPhone6s)]
		let fiveHalfInchDevices: [Device] = [.iPhone6Plus, .iPhone6sPlus, .Simulator(.iPhone6Plus), .Simulator(.iPhone6sPlus)]
		if device.isOneOf(fourInchDevices) {
			thumbnailSize = 60
		} else if device.isOneOf(fiveInchDevices) {
			thumbnailSize = 60
		} else if device.isOneOf(fiveHalfInchDevices) {
			thumbnailSize = 80
		} else if device.isPad {
			thumbnailSize = 76
		} else if device == .iPadPro || device == .Simulator(.iPadPro) {
			thumbnailSize = 84
		}
		else {
			thumbnailSize = 70
		}
		super.init(coder: aDecoder)
	}

	/**
	 To initialize the image view for adding images
	 */
	override func loadView() {
		super.loadView()
		let frameHeight = thumbnailSize! * 1.0
		addNewImageView.translatesAutoresizingMaskIntoConstraints = false

		view.addConstraint(NSLayoutConstraint(item: thumbnailFrame, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: frameHeight))
	}

	/**
	 Additional initializing
	 */
	override func viewDidLoad() {

		self.navigationController?.navigationBar.barStyle = .Black
		super.viewDidLoad()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
		setupViews()
		addGestures()
		replaceImages()

		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWasShown), name: UIKeyboardDidShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIKeyboardWillHideNotification, object: nil)
		setupAlert()
	}

	/**
	 Modify textViews so that it changes when the text is longer than the screen

	 */

	func keyboardWasShown(notification: NSNotification) {
		let info = notification.userInfo! as NSDictionary
		let keyboardRect = info.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
		let keyboardSize = keyboardRect.CGRectValue().size
		self.diaryText.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
		self.diaryText.scrollIndicatorInsets = self.diaryText.contentInset;
	}
	/**
	 Modify back to normal when keyboard is dismissed

	 */
	func keyboardWillBeHidden(notification: NSNotification) {
		self.diaryText.contentInset = UIEdgeInsetsZero;
		self.diaryText.scrollIndicatorInsets = UIEdgeInsetsZero;
	}

	/**
	 Dismiss the keyboard. Used when slide down gesture is detected
	 */
	func dismissKeyboard() {
		diaryText.endEditing(true)
	}

	/**
	 Location manager debugger


	 */
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		print("Reverse geocoder failed with error" + error.localizedDescription)
	}

	/**
	 Modify or create the diary when user hit done
	 */
	func setDiary() {

		if brandNew {
			diary = Diary()
			locationManager.startUpdatingLocation()
			getTimeNow()
			diary!.time = time
			if locationManager.location != nil {
				diary!.location = locationManager.location
			} else {
				diary!.location = CLLocation()
			}
			locationManager.stopUpdatingLocation()
		}
		diary!.text = diaryText.getText()
		diary!.title = diaryTitle.getText()
		diary?.images = self.images
	}

	/**
	 Get the current time
	 */
	func getTimeNow() {
		let date = NSDate()
		time = date.timeIntervalSince1970
	}
	/**
	 Setup segue action when user hit done


	 */
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "addDiary" {
			setDiary()
		}
	}

	/**
	 Override system function
	 */
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		print("Memory warning")
	}

	/**
	 Handle for rotation, replace the images accordingly
	 */
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.replaceImages()
	}
}

// MARK: - Helper functions
extension NewNoteViewController {
	/**
	 Helper function to setup image picker
	 */
	private func setupImagePicker() {
		self.imagepicker.navigationBar.tintColor = UIColor.whiteColor()
		self.imagepicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
		self.imagepicker.delegate = self
		self.imagepicker.allowsEditing = false
	}

	/**
	 One helper function to place the image adder view
	 */
	private func placeImageAdderIfNoImagePresented() {
		thumbnailFrame.addSubview(addNewImageView)
		thumbnailFrame.addConstraint(NSLayoutConstraint(item: addNewImageView, attribute: .CenterX, relatedBy: .Equal, toItem: thumbnailFrame, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
		thumbnailFrame.addConstraint(NSLayoutConstraint(item: addNewImageView, attribute: .CenterY, relatedBy: .Equal, toItem: thumbnailFrame, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
		thumbnailFrame.addConstraint(NSLayoutConstraint(item: addNewImageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: thumbnailSize!))
		thumbnailFrame.addConstraint(NSLayoutConstraint(item: addNewImageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: thumbnailSize!))
		return
	}

	/**
	 Helper function to place all user added images and hide the view for user to add new photoss
	 */
	private func placeImagesIfFull() {
		let screenWidth = UIScreen.mainScreen().bounds.width
		let displacement: CGFloat = 10.0
		let usedspace = CGFloat(imageViews.count) * (thumbnailSize! + displacement) - displacement
		let freeSpace = (screenWidth) - usedspace
		let marginSize = freeSpace / 2
		var count = 0
		for imageView in imageViews {
			thumbnailFrame.addSubview(imageView)
			thumbnailFrame.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: thumbnailSize!))
			thumbnailFrame.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: thumbnailSize!))
			thumbnailFrame.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Left, relatedBy: .Equal, toItem: thumbnailFrame, attribute: .Left, multiplier: 1.0, constant: CGFloat(count) * (thumbnailSize! + displacement) + marginSize))
			thumbnailFrame.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: thumbnailFrame, attribute: .Top, multiplier: 1.0, constant: 0.0))
			count += 1
		}
	}

	/**
	 replace all images when rotated or photo is changed
	 */
	private func replaceImages() {
		for subView in thumbnailFrame.subviews {
			subView.removeFromSuperview()
		}
		if (images.count == 0) {
			placeImageAdderIfNoImagePresented()
		} else if (images.count == 4) {
			placeImagesIfFull()
			return
		} else {
			placeImages()
		}
	}

	/**
	 Helper function used when user had insert some image but is not full
	 */
	private func placeImages() {
		let screenWidth = UIScreen.mainScreen().bounds.width
		let displacement: CGFloat = 10.0
		let usedspace = CGFloat(imageViews.count) * (thumbnailSize! + displacement) + thumbnailSize!
		let freeSpace = (screenWidth) - usedspace
		let marginSize = freeSpace / 2
		var count = 0
		for imageView in imageViews {
			thumbnailFrame.addSubview(imageView)
			thumbnailFrame.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: thumbnailSize!))
			thumbnailFrame.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: thumbnailSize!))
			thumbnailFrame.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Left, relatedBy: .Equal, toItem: thumbnailFrame, attribute: .Left, multiplier: 1.0, constant: CGFloat(count) * (thumbnailSize! + displacement) + marginSize))
			thumbnailFrame.addConstraint(NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: thumbnailFrame, attribute: .Top, multiplier: 1.0, constant: 0.0))
			count += 1
		}
		thumbnailFrame.addSubview(addNewImageView)
		thumbnailFrame.addConstraint(NSLayoutConstraint(item: addNewImageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: thumbnailSize!))
		thumbnailFrame.addConstraint(NSLayoutConstraint(item: addNewImageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: thumbnailSize!))
		thumbnailFrame.addConstraint(NSLayoutConstraint(item: addNewImageView, attribute: .Left, relatedBy: .Equal, toItem: thumbnailFrame, attribute: .Left, multiplier: 1.0, constant: CGFloat(count) * (thumbnailSize! + displacement) + marginSize))
		thumbnailFrame.addConstraint(NSLayoutConstraint(item: addNewImageView, attribute: .Top, relatedBy: .Equal, toItem: thumbnailFrame, attribute: .Top, multiplier: 1.0, constant: 0.0))

	}

	/**
	 Setup the alert for resourceUnavailableAlert
	 */
	private func setupAlert() {
		resourceUnavailableAlert = UIAlertController(title: "Not available".localized, message: "Please go to privacy setting to grant permission".localized, preferredStyle: .Alert)
		let okAction = UIAlertAction(title: "OK".localized, style: .Default, handler: nil)
		let settingAction = UIAlertAction(title: "Setting".localized, style: .Default, handler: { (action) in

			let appSettings = NSURL(string: UIApplicationOpenSettingsURLString)
			UIApplication.sharedApplication().openURL(appSettings!)
		})
		resourceUnavailableAlert?.addAction(settingAction)
		resourceUnavailableAlert?.addAction(okAction)
	}

	/**
	 Helper function to setup the views
	 */
	private func setupViews() {
		diaryTitle.style = TextViewWithPlaceHolder.textViewStyle.Title
		diaryText.style = TextViewWithPlaceHolder.textViewStyle.Text
		if !brandNew {
			diaryTitle.text = titleEditing
			diaryText.text = textEditing
			self.images = []
			self.imageViews = []
		}
		if self.diary?.images.count > 0 {
			for i in(self.diary?.images)! {
				self.insertImage(i)
			}
		}
		if brandNew {
			diaryText.initializePlaceHolder()
			diaryTitle.initializePlaceHolder()
		}
		setupImagePicker()
	}
	/**
	 Helper function to add correct gestures to correct portion of the view
	 */
	private func addGestures() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewNoteViewController.addImage(_:)))
		addNewImageView.addGestureRecognizer(tapGesture)
		addNewImageView.userInteractionEnabled = true
		addNewImageView.contentMode = .ScaleAspectFit
		diaryText.userInteractionEnabled = true
		diaryText.scrollEnabled = true
		let slideDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		slideDownGesture.direction = .Down
		diaryText.addGestureRecognizer(slideDownGesture)
	}
}

// MARK: - Functions for add or remove images
extension NewNoteViewController {
	/**
	 Function for the user to add a image

	 - parameter gesture: the gesture
	 */
	func addImage(gesture: UIGestureRecognizer) {
		// print("add sign clicked")
		let cancelAction = UIAlertAction(title: "Cancel".localized, style: .Cancel, handler: nil)
		let chooseImageAction = UIAlertAction(title: "Choose from library".localized, style: .Default, handler: { (action) in
			let status = PHPhotoLibrary.authorizationStatus()
			if (status == PHAuthorizationStatus.Denied) {
				self.resourceUnavailableAlert?.title = "Photo Library Unavailable".localized
				self.presentViewController(self.resourceUnavailableAlert!, animated: true, completion: nil)
			} else if UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum) {
				self.imagepicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
				self.presentViewController(self.imagepicker, animated: true, completion: nil)
			} else {
				self.resourceUnavailableAlert?.title = "No Photo available".localized
				self.presentViewController(self.resourceUnavailableAlert!, animated: true, completion: nil)
			}
		})
		let takePictureAction = UIAlertAction(title: "Take New Photo".localized, style: .Default, handler: { (action) in
			let status = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
			if status == AVAuthorizationStatus.Denied {
				self.resourceUnavailableAlert?.title = "Camera Unavailable".localized
				self.presentViewController(self.resourceUnavailableAlert!, animated: true, completion: nil)
			}
			else if UIImagePickerController.isSourceTypeAvailable(.Camera) {
				self.imagepicker.sourceType = UIImagePickerControllerSourceType.Camera
				self.presentViewController(self.imagepicker, animated: true, completion: nil)
			} })
		let popupMenu = UIAlertController(title: "Please choose the following actions".localized, message: nil, preferredStyle: .ActionSheet)
		popupMenu.addAction(cancelAction)
		popupMenu.addAction(chooseImageAction)
		if UIImagePickerController.isSourceTypeAvailable(.Camera) {
			popupMenu.addAction(takePictureAction)
		}
		popupMenu.modalPresentationStyle = UIModalPresentationStyle.Popover
		popupMenu.popoverPresentationController?.sourceView = addNewImageView
		popupMenu.popoverPresentationController?.sourceRect = CGRectMake(0, 0, thumbnailSize!, thumbnailSize!)
		self.presentViewController(popupMenu, animated: true, completion: nil)
	}

	/**
	 Image picker delegate. get the picture the user selected

	 */
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
		let image = info[UIImagePickerControllerOriginalImage] as! UIImage
		insertImage(image)
		self.dismissViewControllerAnimated(true, completion: { self.replaceImages() })
	}

	/**
	 Insert the image that the user chose to the view

	 - parameter image: The image to be added
	 */
	func insertImage(image: UIImage) {
		images.append(image)
		let imageView = UIImageView(image: image)
		imageView.contentMode = .ScaleAspectFit
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageViews.append(imageView)
		let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(NewNoteViewController.removeImage(_:)))
		imageView.addGestureRecognizer(longPressGesture)
		imageView.userInteractionEnabled = true
	}

	/**
	 Remove the image when gesture detected

	 */
	func removeImage(gesture: UIGestureRecognizer) {
		/// Setup alert
		let sender = gesture.view as! UIImageView
		comfirmDeletionAlert = UIAlertController(title: "Do you want to remove this image?".localized, message: nil, preferredStyle: .ActionSheet)
		let cancelAction = UIAlertAction(title: "No".localized, style: .Cancel, handler: nil)
		let okAction = UIAlertAction(title: "Yes".localized, style: .Destructive, handler: { (action) in
			self.images.removeAtIndex(self.images.indexOf(sender.image!)!)
			self.imageViews.removeAtIndex(self.imageViews.indexOf(sender)!)
			self.replaceImages()
		})

		comfirmDeletionAlert!.addAction(cancelAction)
		comfirmDeletionAlert!.addAction(okAction)
		if self.presentedViewController == nil {
			comfirmDeletionAlert!.modalPresentationStyle = UIModalPresentationStyle.Popover
			comfirmDeletionAlert!.popoverPresentationController?.sourceView = addNewImageView
			comfirmDeletionAlert!.popoverPresentationController?.sourceRect = CGRectMake(0, 0, thumbnailSize!, thumbnailSize!)
			self.presentViewController(comfirmDeletionAlert!, animated: true, completion: nil)
		}
	}
}
