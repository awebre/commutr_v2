//
//  VehicleListItem.swift
//  commutr_v2
//
//  Created by Austin Webre on 11/18/23.
//

import SwiftUI

struct VehicleListItem: View {
    var vehicle: Vehicle
    var edit: () -> Void
    var delete: () -> Void
    
    var body: some View {
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
                edit()
            } label: {
                Label("Edit", systemImage: "pencil")
            }
        }
        .swipeActions(edge: .leading){
            Button(role: .destructive){
                delete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

#Preview {
    struct Preview : View {
        var doNothing = {}
        var body: some View {
            VehicleListItem(vehicle: Vehicle(make: "Honda", model: "Accord", year: "2023", isPrimary: true), edit: doNothing, delete: doNothing)
        }
        
    }
    
    return Preview()
}
