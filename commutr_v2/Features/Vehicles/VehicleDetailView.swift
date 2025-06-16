//
//  VehicleDetailView.swift
//  commutr_v2
//
//  Created by Austin Webre on 11/18/23.
//

import SwiftUI
import SwiftData

struct VehicleDetailView: View {
    var vehicle: Vehicle
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                LazyVGrid(columns: columns, spacing: 10) {
                    AverageFuelEconomyView(vehicleId: vehicle.id)
                    AverageDistanceView(vehicleId: vehicle.id)
                    AveragePricePerTankView(vehicleId: vehicle.id)
                    AveragePricePerGallonView(vehicleId: vehicle.id)
                }
                .background(Color(.systemGroupedBackground))
                .padding(.bottom, 10)
                
                VehicleFillUpsCardView(vehicle: vehicle)
            }
            
            if #available(iOS 26.0, *){
                // This moved to bottom bar in iOS 26
            } else {
                VStack {
                    Spacer()
                    AddFillUpButton(vehicle: vehicle)
                }
                .padding(.horizontal, 20)
            }
        }
        .toolbar {

                if #available(iOS 26.0, *) {
                    ToolbarSpacer(placement: .bottomBar)
                    ToolbarItem(placement: .bottomBar) {
                        AddFillUpButton(vehicle: vehicle)
                    }
                } else {
                    // Use the old stuff above
                    ToolbarItem(placement: .bottomBar){
                        
                    }
                }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("\(vehicle.getName())")
    }
}

#Preview {
    let container = ModelContainer.previewContainer()
    let vehicle = try! container.mainContext.fetch(FetchDescriptor<Vehicle>()).first!
    VehicleDetailView(vehicle: vehicle)
        .modelContainer(container)
}

extension ModelContainer {
    @MainActor static func previewContainer() -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Vehicle.self, FillUp.self, configurations: config)
        
        let vehicle = Vehicle(make: "Honda", model: "Accord", year: "2023", isPrimary: true)
        
        container.mainContext.insert(vehicle)
        
        let fillUps = [
            FillUp(
                date: Date(),
                distance: 100,
                distanceUnit: .miles,
                fuelAmount: 12.5,
                fuelUnit: .gallons,
                pricePerFuelAmount: 3.59,
                priceUnit: .dollars,
                notes: "Test fill-up"
            ),
            FillUp(
                date: Date(),
                distance: 100,
                distanceUnit: .miles,
                fuelAmount: 12.5,
                fuelUnit: .gallons,
                pricePerFuelAmount: 3.59,
                priceUnit: .dollars,
                notes: "Test fill-up"
            ),
            FillUp(
                date: Date(),
                distance: 100,
                distanceUnit: .miles,
                fuelAmount: 12.5,
                fuelUnit: .gallons,
                pricePerFuelAmount: 3.59,
                priceUnit: .dollars,
                notes: "Test fill-up"
            ),
            FillUp(
                date: Date(),
                distance: 100,
                distanceUnit: .miles,
                fuelAmount: 12.5,
                fuelUnit: .gallons,
                pricePerFuelAmount: 3.59,
                priceUnit: .dollars,
                notes: "Test fill-up"
            ),
            FillUp(
                date: Date(),
                distance: 100,
                distanceUnit: .miles,
                fuelAmount: 12.5,
                fuelUnit: .gallons,
                pricePerFuelAmount: 3.59,
                priceUnit: .dollars,
                notes: "Test fill-up"
            ),
            FillUp(
                date: Date(),
                distance: 100,
                distanceUnit: .miles,
                fuelAmount: 12.5,
                fuelUnit: .gallons,
                pricePerFuelAmount: 3.59,
                priceUnit: .dollars,
                notes: "Test fill-up"
            ),
            FillUp(
                date: Date(),
                distance: 100,
                distanceUnit: .miles,
                fuelAmount: 12.5,
                fuelUnit: .gallons,
                pricePerFuelAmount: 3.59,
                priceUnit: .dollars,
                notes: "Test fill-up"
            ),
            FillUp(
                date: Date(),
                distance: 100,
                distanceUnit: .miles,
                fuelAmount: 12.5,
                fuelUnit: .gallons,
                pricePerFuelAmount: 3.59,
                priceUnit: .dollars,
                notes: "Test fill-up"
            ),
            FillUp(
                date: Date(),
                distance: 100,
                distanceUnit: .miles,
                fuelAmount: 12.5,
                fuelUnit: .gallons,
                pricePerFuelAmount: 3.59,
                priceUnit: .dollars,
                notes: "Test fill-up"
            ),
            FillUp(
                date: Date(),
                distance: 100,
                distanceUnit: .miles,
                fuelAmount: 12.5,
                fuelUnit: .gallons,
                pricePerFuelAmount: 3.59,
                priceUnit: .dollars,
                notes: "Test fill-up"
            ),
            FillUp(
                date: Date(),
                distance: 100,
                distanceUnit: .miles,
                fuelAmount: 12.5,
                fuelUnit: .gallons,
                pricePerFuelAmount: 3.59,
                priceUnit: .dollars,
                notes: "Test fill-up"
            )
        ]
        
        for fillUp in fillUps {
            fillUp.vehicle = vehicle
            container.mainContext.insert(fillUp)
        }
        
        return container
    }
}
