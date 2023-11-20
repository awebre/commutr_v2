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
    @State private var detailsVehicleId: Vehicle.ID?
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(vehicles, selection: $detailsVehicleId) { vehicle in
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
            .confirmationDialog("Delete this Vehicle?", isPresented: $confirmDelete) {
                Button("Delete this vehicle", role: .destructive, action: confirmDeleteItem)
                Button("Cancel", role: .cancel, action: cancelDelete)
            }
        } detail: {
            ZStack{
                if let vehicle = vehicles.first(where: {$0.id == detailsVehicleId}) {
                    VehicleDetailView(vehicle: vehicle)
                } else {
                    Text("Select a Vehicle")
                }
            }
        }
        .onAppear(){
            // Navigate to the details page for the primary on first appearing
            detailsVehicleId = vehicles.first(where: {$0.isPrimary ?? false})?.id
        }
        .sheet(isPresented: $isEditing){
            NavigationStack{
                VehicleAddView(vehicleId: $vehicleId, onClose: closeModal)
            }
            
        }
    }
    
    private func deleteItem(id: Vehicle.ID) {
        vehicleId = id
        confirmDelete = true
    }
    
    private func confirmDeleteItem() {
        withAnimation {
            if let vehicle = vehicles.first(where: {$0.id == vehicleId}) {
                modelContext.delete(vehicle)
            }
        }
        cancelDelete()
    }
    
    private func cancelDelete() {
        vehicleId = nil
        confirmDelete = false
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
