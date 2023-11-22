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
    
    var total: Decimal {
        return MathUtils.totalCost(fuelAmount: self.fuelAmount, pricePerFuelAmount: self.pricePerFuelAmount)
    }
    
    var fuelEconomy: Decimal {
        return MathUtils.fuelEconomy(fuelAmount: self.fuelAmount, distance: self.distance)
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
