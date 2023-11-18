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
    @State private var vehicleId: Vehicle.ID?
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(vehicles, selection: $vehicleId) { vehicle in
                HStack{
                    Text("\(vehicle.getName())")
                    if vehicle.isPrimary {
                        Circle()
                            .fill(.blue)
                            .frame(width: 10, height: 10)
                    }
                }
                .swipeActions(edge: .trailing){
                    Button(){
                        vehicleId = vehicle.id
                        openEditModal()
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                }
                .swipeActions(edge: .leading){
                    Button(role: .destructive){
                        deleteItem(id: vehicle.id)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
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
    
    private func openEditModal() {
        columnVisibility = .detailOnly
        isEditing = true
    }
    
    private func openAddModal() {
        vehicleId = nil
        openEditModal()
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
