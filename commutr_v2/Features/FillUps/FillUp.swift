//
//  FillUps.swift
//  commutr_v2
//
//  Created by Austin Webre on 11/18/23.
//

import Foundation
import SwiftData

@Model
final class FillUp : Identifiable {
    var date: Date?
    var distance: Decimal?
    var distanceUnit: DistanceUnit?
    var fuelAmount: Decimal?
    var fuelUnit: FuelUnit?
    var pricePerFuelAmount: Decimal?
    var priceUnit: PriceUnit?
    var notes: String?
    
    @Relationship(inverse: \Vehicle.fillUps)
    var vehicle: Vehicle?
    
    init(
        date: Date?,
        distance: Decimal?,
        distanceUnit: DistanceUnit?,
        fuelAmount: Decimal?,
        fuelUnit: FuelUnit?,
        pricePerFuelAmount: Decimal?,
        priceUnit: PriceUnit?,
        notes: String?
    ){
        self.date = date
        self.distance = distance
        self.distanceUnit = distanceUnit
        self.fuelAmount = fuelAmount
        self.fuelUnit = fuelUnit
        self.pricePerFuelAmount = pricePerFuelAmount
        self.priceUnit = priceUnit
        self.notes = notes
    }
    
    public func total() -> Decimal {
        if let fuelAmount = self.fuelAmount,
           let price = self.pricePerFuelAmount {
            return fuelAmount * price
        }
        return 0
    }
    
    public func fuelEconomy() -> Decimal {
        if let fuelAmount = self.fuelAmount,
           let distance = self.distance {
            return fuelAmount != 0 ? distance / fuelAmount : 0
        }
        
        return 0
    }
}

enum DistanceUnit : Codable {
    case miles
    case kilometers
}

enum FuelUnit : Codable {
    case gallons
    case liters
}

enum PriceUnit : Codable {
    case dollars
}
