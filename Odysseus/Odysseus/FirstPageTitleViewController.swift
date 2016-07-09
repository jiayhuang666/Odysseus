//
//  FirstPageTitleViewController.swift
//  Odysseus
//
//  Created by HuangJiayu on 4/11/16.
//  Copyright © 2016 Zhengri Fan, Jiayu Huang. All rights reserved.
//

import UIKit
/// A sub-page that display the Date and title of the diary
class FirstPageTitleViewController: UIViewController {
	@IBOutlet weak var DataLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	var date: String?
	var diarytitle: String?
	override func viewDidLoad() {
		super.viewDidLoad()
		self.DataLabel.text = date
		self.titleLabel.text = diarytitle
	}
}
