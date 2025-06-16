//
//  AveragePricePerGallonView.swift
//  commutr_v2
//
//  Created by Austin Webre on 6/16/25.
//

import SwiftUI
import SwiftData

struct AveragePricePerGallonView: View {
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
                GuageView(percentage: Double(truncating: average() as NSNumber) / Double(80))
                    .overlay(
                        VStack {
                            Text("$\(String(describing: average()))")
                                .font(.title)
                            Text("Average Cost per Gallon")
                        }.multilineTextAlignment(.center)
                            .padding(20)
                    )
            }
            .frame(maxWidth: 175, maxHeight: 175)
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(10)
        }
    }
    
    private func average() -> Decimal {
        let validPrices = fillUps.compactMap { $0.pricePerFuelAmount }
        guard !validPrices.isEmpty else { return 0 }
        let totalCost = validPrices.reduce(Decimal(0), +)
        let average = totalCost / Decimal(validPrices.count)
        return MathUtils.round(decimal: average, scale: 2, mode: .bankers)
    }
}

#Preview {
    let container = ModelContainer.previewContainer()
    let vehicle = try! container.mainContext.fetch(FetchDescriptor<Vehicle>()).first!
    AveragePricePerGallonView(vehicleId: vehicle.id)
}
