//
//  SecondPagePhotoViewController.swift
//  Odysseus
//
//  Created by HuangJiayu on 4/11/16.
//  Copyright © 2016 Zhengri Fan, Jiayu Huang. All rights reserved.
//

import UIKit
/// A sub-page that display the images of the diary
class SecondPagePhotoViewController: UIViewController {
	@IBOutlet weak var imageView: UIImageView?
	var image: UIImage?
	override func viewDidLoad() {
		super.viewDidLoad()
		self.imageView!.image = image
	}
}