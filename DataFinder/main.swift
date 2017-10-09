//
//  main.swift
//  DataFinder
//
//  Created by win on 8/23/17.
//  Copyright © 2017 IJ. All rights reserved.
//

import Foundation

var filename = "" // "/Users/win/Downloads/Assignment.txt"
var dateSort: Bool?
var projectId: String?
let dataProcessor = DataProcessor()

repeat {
    print("Please enter complete file path. Ex. /Users/user/Documents/file.txt")
    if let file = readLine() {
        filename = file
    }
} while filename.isEmpty

print("Would you like to sort the results by Start date? Y/N or skip")
if let sort = readLine(), sort.lowercased() == "y" {
    dateSort = true
}

print("Please enter Project ID to filter results or skip")
if let id = readLine(), id != "" {
    projectId = id
}


// Process data request
dataProcessor.processData(filename, dateSort, projectId)
