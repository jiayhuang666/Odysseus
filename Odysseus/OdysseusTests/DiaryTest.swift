//
//  DiaryTest.swift
//  Odysseus
//
//  Created by Zhengri Fan on 4/28/16.
//  Copyright © 2016 Zhengri Fan, Jiayu Huang. All rights reserved.
//

import XCTest
@testable import Odysseus
import CoreLocation

class DiaryTest: XCTestCase {
	let diary = Diary(title: "A title", text: "DIaryNote", location: CLLocation(latitude: 120, longitude: 120), time: 120413.3)

	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

	func testGetCoordinate() {
		XCTAssert((CLLocationCoordinate2D(latitude: 120, longitude: 120).latitude == diary.coordinate.latitude))
		XCTAssert((CLLocationCoordinate2D(latitude: 120, longitude: 120).longitude == diary.coordinate.longitude))
	}

	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measureBlock {
			_ = self.diary.coordinate
		}
	}
}
