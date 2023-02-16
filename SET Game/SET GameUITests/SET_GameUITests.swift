//
//  SET_GameUITests.swift
//  SET GameUITests
//
//  Created by Максим Митрофанов on 16.02.2023.
//

import XCTest

final class SET_GameUITests: XCTestCase {
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        let deal3MoreCardsStaticText = app/*@START_MENU_TOKEN@*/.staticTexts["Deal 3 more cards"]/*[[".buttons[\"Deal 3 more cards\"].staticTexts[\"Deal 3 more cards\"]",".staticTexts[\"Deal 3 more cards\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        deal3MoreCardsStaticText.tap()
        deal3MoreCardsStaticText.tap()
        deal3MoreCardsStaticText.tap()
        deal3MoreCardsStaticText.tap()
        deal3MoreCardsStaticText.tap()
        deal3MoreCardsStaticText.tap()
        deal3MoreCardsStaticText.tap()
        deal3MoreCardsStaticText.tap()
        deal3MoreCardsStaticText.tap()
        deal3MoreCardsStaticText.tap()
        deal3MoreCardsStaticText.tap()
        deal3MoreCardsStaticText.tap()
        deal3MoreCardsStaticText.tap()
        deal3MoreCardsStaticText.tap()
        deal3MoreCardsStaticText.tap()
        deal3MoreCardsStaticText.tap()
        deal3MoreCardsStaticText.tap()
        deal3MoreCardsStaticText.tap()
        deal3MoreCardsStaticText.tap()
        deal3MoreCardsStaticText.tap()
        deal3MoreCardsStaticText.tap()
        deal3MoreCardsStaticText.tap()
        deal3MoreCardsStaticText.tap()
        deal3MoreCardsStaticText.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Start New Game"]/*[[".buttons[\"Start New Game\"].staticTexts[\"Start New Game\"]",".staticTexts[\"Start New Game\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}
