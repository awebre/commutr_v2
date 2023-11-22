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
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    AverageFuelEconomyView(vehicleId: vehicle.id)
                    Spacer()
                }
                .background(Color(.systemGroupedBackground))
                .padding(.top, 20)
                
                VehicleFillUpsCardView(vehicle: vehicle)
            }
            .padding(.bottom, 80)
            
            VStack {
                Spacer()
                AddFillUpButton(vehicle: vehicle)
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("\(vehicle.getName())")
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Vehicle.self, configurations: config)
    
    let vehicle = Vehicle(make: "Honda", model: "Accord", year: "2023", isPrimary: true)
    container.mainContext.insert(vehicle);
    return VehicleDetailView(vehicle: vehicle)
        .modelContainer(container)
}
