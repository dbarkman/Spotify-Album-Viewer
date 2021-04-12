//
//  EchoBind_SpotifyUITests.swift
//  EchoBind-SpotifyUITests
//
//  Created by David Barkman on 4/11/21.
//

import XCTest

class EchoBind_SpotifyUITests: XCTestCase {

    func testViewCount() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertEqual(
            app.staticTexts.count,
            3,
            "There should be three views for an account with no albums saved to their Spotify library."
        )
    }

}
