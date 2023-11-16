//
//  Vehicle.swift
//  commutr_v2
//
//  Created by Austin Webre on 11/14/23.
//

import Foundation
import SwiftData

@Model
final class Vehicle : Identifiable {
    var make: String;
    var model: String;
    var year: String;
    var isPrimary: Bool;
    
    init(make: String, model: String, year: String, isPrimary: Bool){
        self.make = make;
        self.model = model;
        self.year = year;
        self.isPrimary = isPrimary;
    }
}
