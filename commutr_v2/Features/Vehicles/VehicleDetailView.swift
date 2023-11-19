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
            VStack() {

            }
            VStack {
                Spacer()
                Button(action: { }) {
                        Text("Add Fill Up")
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .foregroundColor(.white)
                    .background(.teal)
                    .cornerRadius(10)
            }.padding(.horizontal, 20)
        }.navigationTitle("\(vehicle.getName())")

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
