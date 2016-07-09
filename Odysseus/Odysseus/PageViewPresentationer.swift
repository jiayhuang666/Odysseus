//
//  PageViewPresentationer.swift
//  Odysseus
//
//  Created by HuangJiayu on 4/11/16.
//  Copyright © 2016 Zhengri Fan, Jiayu Huang. All rights reserved.
//

import UIKit
/// PageView Controller that can show users fancy pages of the diary
class PageViewPresentationer: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

	var pages = [UIViewController]()
	var diary: Diary?

	/**
	 Initialize the page view controller
	 */
	override func viewDidLoad() {
		if diary == nil {
			diary = Diary()
		}
		super.viewDidLoad()

		self.delegate = self
		self.dataSource = self

		let page1: FirstPageTitleViewController! = (storyboard?.instantiateViewControllerWithIdentifier("textDiaryPresentation")) as! FirstPageTitleViewController

		let page3: MapViewPresentation! = storyboard?.instantiateViewControllerWithIdentifier("MapStoryPresentation") as! MapViewPresentation

		let page4: TextContentViewController! = (storyboard?.instantiateViewControllerWithIdentifier("textContentViewController")) as! TextContentViewController
		page1.diarytitle = diary?.title
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "yy-MM-dd" // superset of OP's format
		let str = dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: (diary?.time)!))
		page1.date = str
		pages.append(page1)
		if diary!.text != "" {
			page4.textInfo = diary!.text
			pages.append(page4)
		}

		for i in(diary?.images)! {
			let page2: SecondPagePhotoViewController! = (storyboard?.instantiateViewControllerWithIdentifier("PictureStoryPresentation")) as! SecondPagePhotoViewController
			page2.image = i
			pages.append(page2)
		}
		page3.latitude = diary?.location?.coordinate.latitude
		page3.longitude = diary?.location?.coordinate.longitude
		pages.append(page3)

		let pageControl = UIPageControl.appearance()
		pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
		pageControl.currentPageIndicatorTintColor = UIColor.darkGrayColor()
		pageControl.backgroundColor = UIColor.clearColor()

		setViewControllers([page1], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
	}

	/**
	 Implement the scrolling of the pageViewController
	 */
	func pageViewController(pageViewController: UIPageViewController,
		viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
			guard let viewControllerIndex = pages.indexOf(viewController) else {
				return nil
			}

			let previousIndex = viewControllerIndex - 1

			guard previousIndex >= 0 else {
				return nil
			}

			guard pages.count > previousIndex else {
				return nil
			}

			return pages[previousIndex]
	}
	/**
	 Implement the scrolling of the pageViewController
	 */
	func pageViewController(pageViewController: UIPageViewController,
		viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
			guard let viewControllerIndex = pages.indexOf(viewController) else {
				return nil
			}

			let nextIndex = viewControllerIndex + 1
			let orderedViewControllersCount = pages.count

			guard orderedViewControllersCount != nextIndex else {
				return nil
			}

			guard orderedViewControllersCount > nextIndex else {
				return nil
			}

			return pages[nextIndex]
	}
	/**
	 Return the size of the page set
	 */
	func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
		return pages.count
	}
	/**
	 The starting index
	 */
	func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
		return 0
	}
}
