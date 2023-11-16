//
//  VehicleAddView.swift
//  commutr_v2
//
//  Created by Austin Webre on 11/14/23.
//

import SwiftUI
import SwiftData

struct VehicleAddView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var vehicles: [Vehicle]
    
    var vehicle: Vehicle;
    @StateObject private var model = VehicleFormModel();
    
    var onClose: () -> Void;
    var body: some View {
        Form {
            TextField("Make", text: $model.make)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save", action: save)
            }
        }
        .onAppear(){
            model.id = vehicle.id
            model.make = vehicle.make
            model.model = vehicle.model
            model.year = vehicle.year
            model.isPrimary = vehicle.isPrimary
        }
    }
    
    private func save(){
        vehicle.make = model.make
        vehicle.model = model.model
        vehicle.year = model.year
        vehicle.isPrimary = model.isPrimary
        if vehicles.first(where: {$0.id == vehicle.id}) == nil{
            modelContext.insert(vehicle)
        }
        onClose()
    }
}

class VehicleFormModel : ObservableObject {
    var id: Vehicle.ID?
    var make = ""
    var model = ""
    var year = ""
    var isPrimary = false
}

#Preview {
    struct Preview: View {
        var body: some View {
            VehicleAddView(vehicle: Vehicle(make: "", model: "", year: "", isPrimary: false), onClose: {}).modelContainer(for: Vehicle.self, inMemory: true)
        }
    }
    
    return Preview()
}