//
//  TextViewWithPlaceHolder.swift
//  Odysseus
//
//  Created by Zhengri Fan on 4/10/16.
//  Copyright © 2016 Zhengri Fan, Jiayu Huang. All rights reserved.
//

import UIKit
/// Customized textview with placeHolders in it.
class TextViewWithPlaceHolder: UITextView, UITextViewDelegate {

	/*
	 // Only override drawRect: if you perform custom drawing.
	 // An empty implementation adversely affects performance during animation.
	 override func drawRect(rect: CGRect) {
	 // Drawing code
	 }
	 */

	let titlePlaceHolderText: String = "Anything set to title".localized
	let textPlaceHolderText: String = "What do you want to say".localized
	var style: textViewStyle = textViewStyle.Text
	let textViewDefaultAlpha: CGFloat = 1.0
	let textViewPlaceHolderAlpha: CGFloat = 0.5

	enum textViewStyle {
		case Text
		case Title
	}

	/**
	 Initialize the textview

	 */
	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		self.delegate = self
		self.tintColor = UIColor.lightGrayColor()
	}

	/**
	 Initialize the textview

	 */
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.delegate = self
		self.tintColor = UIColor.lightGrayColor()
	}

	/**
	 Initialize the place holder

	 */
	func initializePlaceHolder() {
		if self.text == "" {
			if (self.style == textViewStyle.Text) {
				self.text = textPlaceHolderText
			}
			if (self.style == textViewStyle.Title) {
				self.text = titlePlaceHolderText
			}
			self.alpha = textViewPlaceHolderAlpha
		}
	}

	// MARK:- PlaceHolder implementtation
	// Inspried by CmKndy, http://stackoverflow.com/questions/1328638/placeholder-in-uitextview

	/**
	 clear the placeholder text when user starts editing

	 */
	func textViewDidBeginEditing(textView: UITextView) {

		if (textView.text == titlePlaceHolderText) {
			textView.alpha = textViewDefaultAlpha
			textView.text = ""
			return
		}
		if (textView.text == textPlaceHolderText) {
			textView.alpha = textViewDefaultAlpha
			textView.text = ""
		}
	}

	/**
	 Place the placeholder if user leave the textview as a blank

	 */
	func textViewDidEndEditing(textView: UITextView) {
		if (self.style == textViewStyle.Title && textView.text == "") {
			textView.alpha = textViewPlaceHolderAlpha
			textView.text = titlePlaceHolderText
		}
		if (self.style == textViewStyle.Text && textView.text == "") {
			textView.alpha = textViewPlaceHolderAlpha
			textView.text = textPlaceHolderText
		}
	}

	/**
	 Get the user typed text. Check if the text in the view is the placeholder text or not

	 - returns: the text user typed
	 */
	func getText() -> String {
		if (self.style == textViewStyle.Title) {
			if (self.text == titlePlaceHolderText) {
				return ""
			}
		} else if (self.style == textViewStyle.Text) {
			if (self.text == textPlaceHolderText) {
				return ""
			}
		}
		return self.text
	}
}
