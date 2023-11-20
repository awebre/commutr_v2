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
    
    @State var isEditing = false
    @State var fillUpId: FillUp.ID?
    
    var body: some View {
        ZStack {
            VStack() {
                
            }
            VStack {
                Spacer()
                Button(action: addFillUp) {
                    Text("Add Fill Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .foregroundColor(.white)
                .background(.teal)
                .cornerRadius(10)
            }.padding(.horizontal, 20)
        }
        .navigationTitle("\(vehicle.getName())")
        .sheet(isPresented: $isEditing){
            NavigationStack{
                FillUpFormView(fillUpId: $fillUpId, onClose: closeModal)
            }
        }
    }
    
    private func addFillUp(){
        fillUpId = nil
        isEditing = true
    }
    
    private func closeModal() {
        fillUpId = nil
        isEditing = false
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
