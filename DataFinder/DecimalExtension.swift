//
//  DecimalExtension.swift
//  DataFinder
//
//  Created by win on 8/23/17.
//  Copyright © 2017 IJ. All rights reserved.
//

import Foundation

// Extension to return the number of decimal places in a decimal
extension Decimal {
    var countDecimalDigits: Int {
        return max(-exponent, 0)
    }
}
