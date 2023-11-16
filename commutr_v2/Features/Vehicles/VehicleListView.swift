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
    
    @StateObject private var model = Model();
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic
    @State private var isEditing = false;
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(vehicles, selection: $model.vehicleId) { vehicle in
                Text(vehicle.make)
                    .swipeActions(edge: .trailing){
                        Button(){
                            model.vehicleId = vehicle.id
                            openEditModel();
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
            .navigationTitle("Your Vehicle")
            .toolbar {
                ToolbarItem {
                    Button(action: openEditModel) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            if model.vehicleId != nil {
                Text("Details for selected")
            } else {
                
                Text("Select a Vehicle")
            }
            
        }
        .sheet(isPresented: $isEditing){
            NavigationStack{
                if let vehicle = vehicles.first(where: {$0.id == model.vehicleId}){
                    VehicleAddView(vehicle: vehicle, onClose: closeModal)
                        .navigationTitle("Edit \(vehicle.make)")
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    isEditing = false
                                }
                            }
                        }
                } else {
                    VehicleAddView(vehicle: Vehicle(make: "", model: "", year: "", isPrimary: false), onClose: closeModal)
                        .navigationTitle("Add Vehicle")
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    isEditing = false
                                }
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
    
    private func openEditModel() {
        columnVisibility = .detailOnly;
        isEditing = true;
    }
    
    private func closeModal() {
        isEditing = false;
    }
    
    private class Model : ObservableObject {
        var vehicleId: Vehicle.ID?
    }
}

#Preview {
    VehicleListView()
        .modelContainer(for: Vehicle.self, inMemory: true)
}
