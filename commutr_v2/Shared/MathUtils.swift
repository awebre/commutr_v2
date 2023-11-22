//
//  MathUtils.swift
//  commutr_v2
//
//  Created by Austin Webre on 11/21/23.
//

import Foundation

class MathUtils {
    static func fuelEconomy(fuelAmount: Decimal?, distance: Decimal?) -> Decimal {
        if let f = fuelAmount,
           let d = distance {
            var result = f != 0 ? d / f : 0
            var rounded = Decimal()
            NSDecimalRound(&rounded, &result, 2, .bankers)
            return rounded
        }
        
        return 0
    }
    
    static func totalCost(fuelAmount: Decimal?, pricePerFuelAmount: Decimal?) -> Decimal {
        if let fuel = fuelAmount,
           let price = pricePerFuelAmount {
            var result = fuel * price
            var rounded = Decimal()
            NSDecimalRound(&rounded, &result, 2, .bankers)
            return rounded
        }
        return 0
    }
}
