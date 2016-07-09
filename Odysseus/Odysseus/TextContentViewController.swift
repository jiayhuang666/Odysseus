//
//  TextContentViewController.swift
//  Odysseus
//
//  Created by HuangJiayu on 4/11/16.
//  Copyright © 2016 Zhengri Fan, Jiayu Huang. All rights reserved.
//

import UIKit
/// A sub-page that display the text of the diary
class TextContentViewController: UIViewController {

	@IBOutlet weak var textViewContent: UITextView!
	var textInfo: String?
	override func viewDidLoad() {
		super.viewDidLoad()
		self.textViewContent.text = textInfo
	}
}
