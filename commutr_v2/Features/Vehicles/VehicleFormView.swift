//
//  VehicleAddView.swift
//  commutr_v2
//
//  Created by Austin Webre on 11/14/23.
//

import SwiftUI
import SwiftData

struct VehicleFormView: View {
    @Binding var vehicleId: Vehicle.ID?
    @Environment(\.modelContext) private var modelContext
    @Query private var vehicles: [Vehicle]
    
    @StateObject private var model = VehicleFormModel();
    
    var onClose: () -> Void;
    var body: some View {
        Form {
            TextField("Year", text: $model.year)
                .keyboardType(.numberPad) //TODO: actual validation of this field
            TextField("Make", text: $model.make)
            TextField("Model", text: $model.model)
            Toggle("Primary", isOn: $model.isPrimary)
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(vehicleId != nil ? "Edit \(model.make) \(model.model) \(model.year)" : "Add Vehicle")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", systemImage: "xmark", action: onClose)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if #available(iOS 26.0, *) {
                    Button("Save", systemImage: "checkmark", role: .confirm, action: save)

                } else {
                    Button("Save", systemImage: "checkmark", action: save)
                }
            }
        }
        .onAppear(){
            let vehicle = vehicles.first(where: { $0.id == vehicleId }) ?? Vehicle(make: "", model: "", year: "", isPrimary: false)
            model.id = vehicle.id
            model.make = vehicle.make ?? ""
            model.model = vehicle.model ?? ""
            model.year = vehicle.year ?? ""
            model.isPrimary = vehicle.isPrimary ?? false
        }
    }
    
    private func save(){
        
        if let vehicle = vehicles.first(where: { $0.id == model.id }){
            vehicle.make = model.make
            vehicle.model = model.model
            vehicle.year = model.year
            vehicle.isPrimary = model.isPrimary
        } else {
            modelContext.insert(Vehicle(make: model.make, model: model.model, year: model.year, isPrimary: model.isPrimary))
        }

        
        if(model.isPrimary){
            vehicles.filter({ $0.id != model.id && ($0.isPrimary ?? false) }).forEach({
                $0.isPrimary = false
            })
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
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Vehicle.self, configurations: config)
    
    let vehicle = Vehicle(make: "Honda", model: "Accord", year: "2023", isPrimary: true)
    container.mainContext.insert(vehicle);
    
    struct Preview: View {
        var id: Vehicle.ID?
        @State var vehicleId: Vehicle.ID?
        var body: some View {
            VehicleFormView(vehicleId: $vehicleId, onClose: {})
                .onAppear(){
                    vehicleId = id
                }
        }
    }
    
    return Preview(id: vehicle.id).modelContainer(container)
}
