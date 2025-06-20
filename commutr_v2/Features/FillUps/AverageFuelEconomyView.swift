//
//  AverageFuelEconomyView.swift
//  commutr_v2
//
//  Created by Austin Webre on 11/21/23.
//

import SwiftUI
import SwiftData

struct AverageFuelEconomyView: View {
    @Query private var fillUps: [FillUp]
    
    init(vehicleId: Vehicle.ID) {
        let defaultDate = Date.now //hack for option date filter
        let minDate = Calendar.current.date(byAdding: .month, value: -3, to: Date.now) ?? Date.now
        let predicate = #Predicate<FillUp> {
            $0.vehicle?.persistentModelID == vehicleId &&
            ($0.date != nil && $0.date ?? defaultDate >= minDate)
        }
        let descriptor = FetchDescriptor<FillUp>(predicate: predicate,
                                                 sortBy: [SortDescriptor(\.date, order: .reverse)])
        
        _fillUps = Query(descriptor)
    }
    
    var body: some View {
        if(fillUps.count < 1) {
            EmptyView()
        } else {
            VStack {
                GuageView(percentage: Double(truncating: average() as NSNumber) / Double(60))
                    .overlay(
                        VStack {
                            Text("\(String(describing: average()))")
                                .font(.title)
                            Text("Average MPG")
                        }.multilineTextAlignment(.center)
                            .padding(20)
                    )
            }
            .frame(width: 175, height: 175)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(10)
        }
    }
    
    private func average() -> Decimal {
        let totalFuelEconomy = fillUps.map({$0.fuelEconomy}).reduce(0, +)
        let average = totalFuelEconomy / Decimal(fillUps.count)
        return MathUtils.round(decimal: average, scale: 2, mode: .bankers)
    }
}

//#Preview {
//    AverageFuelEconomyView()
//}
