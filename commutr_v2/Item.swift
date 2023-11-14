//
//  Item.swift
//  commutr_v2
//
//  Created by Austin Webre on 11/14/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
