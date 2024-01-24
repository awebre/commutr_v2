//
//  MathUtils.swift
//  commutr_v2
//
//  Created by Austin Webre on 11/21/23.
//

import Foundation

class MathUtils {
    static func fuelEconomy(fuelAmount: Decimal?, distance: Decimal?) -> Decimal {
        if let fuel = fuelAmount,
           let d = distance {
            let result = fuel != 0 ? d / fuel : 0
            return self.round(decimal: result, scale: 2, mode: .bankers)
        }
        
        return 0
    }
    
    static func totalCost(fuelAmount: Decimal?, pricePerFuelAmount: Decimal?) -> Decimal {
        if let fuel = fuelAmount,
           let price = pricePerFuelAmount {
            let result = fuel * price
            return self.round(decimal: result, scale: 2, mode: .bankers)
        }
        return 0
    }
    
    static func round(decimal: Decimal, scale: Int, mode: NSDecimalNumber.RoundingMode) -> Decimal{
        var copy = decimal
        var rounded = Decimal()
        NSDecimalRound(&rounded, &copy, scale, mode)
        return rounded
    }
}
