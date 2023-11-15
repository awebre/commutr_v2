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
    
    @State private var action: VehicleAction?
    @State private var vehicleId: Vehicle.ID?
    @State private var columnVisibility = NavigationSplitViewVisibility.automatic
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(vehicles, selection: $vehicleId) { vehicle in
                Text(vehicle.make)
                    .swipeActions(edge: .trailing){
                        Button(){
                            //TODO: 
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
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            switch action {
            case .add:
                Text("Adding")
            case .edit:
                if let vehicle = vehicles.first(where: {$0.id == vehicleId}){
                    Text("Editing \(vehicle.year) \(vehicle.make) \(vehicle.model)")
                }
            default:
                Text("Select a Vehicle")
            }
            
        }
    }
    
    private func deleteItem(id: Vehicle.ID) {
        withAnimation {
            if let vehicle = vehicles.first(where: {$0.id == id}) {
                modelContext.delete(vehicle);
            }
        }
    }
    
    private func addItem() {
        columnVisibility = .detailOnly;
        withAnimation {
            let newItem = Vehicle(make: "", model: "", year: 0, isPrimary: false)
            modelContext.insert(newItem)
            vehicleId = newItem.id
        }
        action = .add;
    }
    
    enum VehicleAction {
        case add
        case edit
    }
}

#Preview {
    VehicleListView()
        .modelContainer(for: Vehicle.self, inMemory: true)
}
