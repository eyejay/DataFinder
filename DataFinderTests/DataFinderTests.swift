//
//  DataFinderTests.swift
//  DataFinderTests
//
//  Created by win on 8/23/17.
//  Copyright © 2017 IJ. All rights reserved.
//

import XCTest
@testable import DataFinder

class DataFinderTests: XCTestCase {
    
    let dataProcessor = DataProcessor()
    
    // Test if readFile returns nil for wrong file paths
    func testReadFile() {
        // Incomplete file path
        let file = "somefile"
        XCTAssertNil(dataProcessor.readFile(file))
    }
    
    // Test if cleanFile formats the text \n\n -> \n, \r -> \n and NULL -> ""
    func testCleanFile() {
        let text = "Example Text \n\n This is just an example text with no NULL values and empty lines \r\n"
        let output = "Example Text \n This is just an example text with no  values and empty lines \n"
        XCTAssertEqual(dataProcessor.cleanFile(text), output)
    }
    
    // Test if data is collected between rows /*** and commented(#) lines skipped
    //    Example Text \n
    //    /***** \n
    //    Hello\n
    //    #Comment\n
    //    /***** \n
    //    Some more text \n
    //    /***** \n
    //    World\n
    //    /***** \n
    //    end text
    func testUsableData() {
        // Should fetch data between /*****
        let text = "Example Text \n/***** \nHello\n#Comment\n/***** \n Some more text \n/***** \nWorld\n/***** \n end text"
        let output = ["Hello", "World"]
        XCTAssertEqual(dataProcessor.getUsableData(text), output)
        
        // No /*****, should return empty string
        let text2 = "Example Text \n Hello World \n end text"
        XCTAssertTrue(dataProcessor.getUsableData(text2).isEmpty)
    }
    
    // Test date if its the right specific format
    func testDateFormat() {
        // Correct date format yyyy-MM-dd hh:mm:ss.SSS
        let correctDate = "2013-01-01 00:00:00.000"
        XCTAssertTrue(dataProcessor.isDateFormatCorrect(correctDate))
        
        // Wrong date format yyyy-MM-dd hh:mm:ss missing milliseconds
        let wrongDate1 = "2013-01-01 00:00:00"
        XCTAssertFalse(dataProcessor.isDateFormatCorrect(wrongDate1))
        
        // Wrong date format yyyy-MM-dd
        let wrongDate2 = "2013-01-01"
        XCTAssertFalse(dataProcessor.isDateFormatCorrect(wrongDate2))
    }
    
    // Test if Savings amount is of right format
    func testSavingsAmountDecimal() {
        // Correct format with 6 decimal places
        let rightAmount = "1234.123456"
        XCTAssertTrue(dataProcessor.isSavingsFormatCorrect(rightAmount))
        
        // Wrong format with 7 decimal places
        let wrongAmount = "1234.1234567"
        XCTAssertFalse(dataProcessor.isSavingsFormatCorrect(wrongAmount))
    }
    
    // Test if complexity type exists
    func testComplexityType() {
        // Correct values ["Simple","Moderate","Hazardous"]
        let complexity = "Simple"
        XCTAssertTrue(dataProcessor.isComplexityCorrect(complexity))
        
        // Unknown complexity type
        let wrongComplexity = "Hard"
        XCTAssertFalse(dataProcessor.isComplexityCorrect(wrongComplexity))
    }
}
