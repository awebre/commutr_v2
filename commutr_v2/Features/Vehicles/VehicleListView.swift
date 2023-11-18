//
//  ContentView.swift
//  commutr_v2
//
//  Created by Austin Webre on 11/14/23.
//

import SwiftUI
import SwiftData

struct VehicleListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var vehicles: [Vehicle]
    
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic
    @State private var isEditing = false
    @State var confirmDelete = false
    @State private var vehicleId: Vehicle.ID?
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(vehicles, selection: $vehicleId) { vehicle in
                VehicleListItem(vehicle: vehicle, edit: {openEditModal(id: vehicle.id)}, delete: {deleteItem(id: vehicle.id)})
                
            }
            .navigationTitle("Your Vehicles")
            .toolbar {
                ToolbarItem {
                    Button(action: openAddModal) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            ZStack{
                if vehicleId != nil {
                    Text("Details for selected")
                } else {
                    Text("Select a Vehicle")
                }
            }
        }
        .onAppear(){
            // Navigate to the details page for the primary on first appearing
            vehicleId = vehicles.first(where: {$0.isPrimary})?.id
        }
        .sheet(isPresented: $isEditing){
            NavigationStack{
                if let vehicle = vehicles.first(where: {$0.id == vehicleId}){
                    VehicleAddView(vehicle: vehicle, onClose: closeModal)
                        .navigationTitle("Edit \(vehicle.year) \(vehicle.make) \(vehicle.model)")
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel", action: closeModal)
                            }
                        }
                } else {
                    VehicleAddView(vehicle: Vehicle(make: "", model: "", year: "", isPrimary: false), onClose: closeModal)
                        .navigationTitle("Add Vehicle")
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel", action: closeModal)
                            }
                        }
                }
                
            }
            
        }
    }
    
    private func deleteItem(id: Vehicle.ID) {
        withAnimation {
            if let vehicle = vehicles.first(where: {$0.id == id}) {
                modelContext.delete(vehicle)
            }
        }
    }
    
    private func openEditModal(id: Vehicle.ID) {
        vehicleId = id
        openModal()
    }
    
    private func openAddModal() {
        vehicleId = nil
        openModal()
    }
    
    private func openModal() {
        columnVisibility = .detailOnly
        isEditing = true
    }
    
    private func closeModal() {
        vehicleId = nil
        isEditing = false
    }
    
    private class Model : ObservableObject {
        var vehicleId: Vehicle.ID?
    }
}

#Preview {
    VehicleListView()
        .modelContainer(for: Vehicle.self, inMemory: true)
}
