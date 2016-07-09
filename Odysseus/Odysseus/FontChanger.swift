//
//  FontChanger.swift
//  Odysseus
//
//  Created by HuangJiayu on 4/11/16.
//  Copyright © 2016 Zhengri Fan, Jiayu Huang. All rights reserved.
//
//

import UIKit
// MARK: - Change UILabel font entry
// MARK: - Change UITextView font entry
// MARK: - Change UIButton font entry
extension UILabel {

	var substituteFontName: String {
		get { return self.font.fontName }
		set { self.font = UIFont(name: newValue, size: self.font.pointSize) }
	}
}

extension UITextView {

	var substituteFontName: String {
		get { return self.font!.fontName }
		set { self.font = UIFont(name: newValue, size: self.font!.pointSize) }
	}
}

extension UIButton {

	var substituteFontName: String {
		get { return self.titleLabel!.font.fontName }
		set { self.titleLabel!.font = UIFont(name: newValue, size: self.titleLabel!.font.pointSize) }
	}
}

// MARK: - Inspired from :http://stackoverflow.com/questions/25081757/whats-nslocalizedstring-equivalent-in-swift
// Get localized string
// By: dr OX and Danyal Aytekin
extension String {
	var localized: String {
		return NSLocalizedString(self, tableName: "mainStrings", bundle: NSBundle.mainBundle(), value: "", comment: "")
	}
}
