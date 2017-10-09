//
//  DataProcessor.swift
//  DataFinder
//
//  Created by win on 8/23/17.
//  Copyright © 2017 IJ. All rights reserved.
//

import Foundation

class DataProcessor {
    
    // MARK: - Properties
    
    var columnTitles: [String] = []
    let dateFormatter = DateFormatter()
    // Complexity items array, new items can be added here
    let complexityTypes = ["Simple", "Moderate", "Hazardous"]
    
    
    // MARK: - Methods
    
    // Read the file and format useful data
    func processData(_ filePath: String, _ sortByDateAsc: Bool?, _ projectId: String?) {
        if filePath == "" {
            print("File name/path missing! Please provide full file path.")
            return
        }
        // Read the file and return contents, or nil if reading error
        if let fileData = readFile(filePath) {
            // Clean the file with possible formatting
            let cleanedData = cleanFile(fileData)
            // Get useful information in the file
            let usableRows = getUsableData(cleanedData)
            if usableRows.count > 0 {
                // Format data into dictionaries with and without projectId filter
                if let formattedData = formatData(usableRows, projectId) {
                    // Sort the data by ascending date if required
                    if sortByDateAsc != nil && sortByDateAsc! {
                        let sortedData = sortByDate(formattedData)
                        printData(sortedData)
                    } else {
                        printData(formattedData)
                    }
                }
            } else {
                print("No usable data in file!")
            }
        } else {
            print("Error reading file! Please check file path \(filePath)")
        }
    }
    
    // Format data into dictionaries based on projectId
    func formatData(_ usableRows: [String], _ projectId: String?) -> [[String:String]]? {
        // Array of dictionaries to be returned as main useful data source
        var data:[[String:String]] = []
        for row in usableRows {
            // Take the first row as column names and start with second row
            if row == usableRows.first {
                columnTitles = usableRows.first!.components(separatedBy: "\t")
                continue
            }
            // Take fields separated by tabs
            let fields = row.components(separatedBy: "\t")
            // Skip the row if fields are not equal to number of columns: Incomplete data
            if fields.count != columnTitles.count {continue}
            
            // Check if date, savings amount and complexity have correct formats or values
            if !isDataFormatValid(fields) {
                // Return if format or values are invalid
                return nil
            }
            // Check if project should be filtered by porjectId, skip all other rows
            if let index = columnTitles.index(of: "Project") {
                if projectId != nil && fields[index] != projectId! {
                    continue
                }
            }
            // Save the fields at respective column index in dictionary
            var dataRow: [String:String] = [:]
            for (index,field) in fields.enumerated(){
                let fieldName = columnTitles[index]
                dataRow[fieldName] = field
            }
            // Add the dictionary in array of dictionaries
            data += [dataRow]
        }
        // If no data found, return nil
        if !data.isEmpty {
            return data
        } else {
            print("No data found! Please check your search criteria")
            return nil
        }
    }
    
    // Check if Start date, Savings amount and Complexity have valid formats/values
    func isDataFormatValid(_ fields: [String]) -> Bool {
        // Check if Start Date format is correct, quit otherwise
        if let dateIndex = columnTitles.index(of: "Start date"), !isDateFormatCorrect(fields[dateIndex]) {
            print("Error: Incorrect Start date at \(fields)")
            print("Correct date format is yyyy-MM-dd hh:mm:ss.SSS, Terminating...")
            return false
        }
        // Check if Savings amount format is correct with 6 significant figures, quit otherwise
        if let savingsIndex = columnTitles.index(of: "Savings amount") {
            let savings = fields[savingsIndex]
            if savings != "" && !isSavingsFormatCorrect(savings) {
                print("Error: Incorrect Savings amount at \(fields)")
                print("Savings amount must have <= 6 significant decimal places. Terminating...")
                return false
            }
        }
        // Check if Complexity exists, quit otherwise
        if let complexityIndex = columnTitles.index(of: "Complexity"), !isComplexityCorrect(fields[complexityIndex]) {
            print("Error: Incorrect Complexity value at \(fields)")
            print("Correct values are \(complexityTypes). Terminating...")
            return false
        }
        return true
    }
    
    // Read the file and return contents, or nil if reading error
    func readFile(_ filePath: String) -> String? {
        do {
            let fileData = try String(contentsOfFile: filePath, encoding: .utf8)
            return fileData
        } catch {
            return nil
        }
    }
    
    // Clean the file with possible formatting
    func cleanFile(_ data: String) -> String {
        var cleanData = data
        // Replace possible \r with \n
        cleanData = cleanData.replacingOccurrences(of: "\r", with: "\n")
        // Remove any additional new lines or empty lines
        cleanData = cleanData.replacingOccurrences(of: "\n\n", with: "\n")
        // Replace NULL values with empty space
        cleanData = cleanData.replacingOccurrences(of: "NULL", with: "")
        return cleanData
    }
    
    // Get useful information in the file
    func getUsableData(_ data: String) -> [String] {
        // Read data line by line
        let rows = data.components(separatedBy: .newlines)
        var startReading = false
        var usableData = [String]()
        for row in rows {
            // If  row with stars is found, set start reading flag to true
            if row.hasPrefix("/*****") {
                if startReading == true {
                    startReading = false
                } else {
                    startReading = true
                }
                continue
            }
            // Collect data if start reading flag is set and row is not a comment (#)
            if startReading && !row.hasPrefix("#") {
                usableData.append(row)
            }
        }
        return usableData
    }
    
    // Sort data by Date - Ascending
    func sortByDate(_ data: [[String:String]]) -> [[String:String]]{
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSS"
        let sortedArray = data.sorted { [dateFormatter] arrayOne, arrayTwo in
            return dateFormatter.date(from:arrayOne["Start date"]! )! < dateFormatter.date(from: arrayTwo["Start date"]! )!
        }
        return sortedArray
    }
    
    // Check if date format is correct
    func isDateFormatCorrect(_ strDate: String) -> Bool {
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSS"
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT") as TimeZone!
        if let _ = dateFormatter.date(from: strDate) {
            return true
        } else {
            return false
        }
    }
    
    // Check savings amount format for decimal values // *.123456
    func isSavingsFormatCorrect(_ amount: String) -> Bool {
        let decimalAmount = Decimal(string: amount)!
        return decimalAmount.countDecimalDigits <= 6
    }
    
    // Check if complexity has correct type
    func isComplexityCorrect(_ complexity: String) -> Bool {
        return complexityTypes.contains(complexity)
    }
    
    // Create a string from given data in the form of matrix and display
    func printData(_ data: [[String:String]]){
        var matrixString = ""
        var rowString = ""
        // Print the header line with column names
        var columnNames = ""
        for title in columnTitles {
            columnNames += "\(title)     " // Add space between fields
        }
        print(columnNames)
        
        // Create matrix string with row fields' indexes based on column titles
        for row in data{
            rowString = ""
            for fieldName in columnTitles{
                guard let field = row[fieldName] else {
                    print("Field not found: \(fieldName)")
                    continue
                }
                rowString += String(format:"%@     ",field)
            }
            matrixString += rowString + "\n"
        }
        // Print matrix
        print(matrixString)
    }
}
