//
//  VehicleFillUpsCardView.swift
//  commutr_v2
//
//  Created by Austin Webre on 11/21/23.
//

import SwiftUI

struct VehicleFillUpsCardView: View {
    var vehicle: Vehicle
    @State var showAll = false
    @State var fillUpId: FillUp.ID?
    
    var body: some View {
        VStack {
            FillUpsListView(vehicleId: vehicle.id,
                            showAll: showAll,
                            edit: edit,
                            onToggleShowAll: {showAll = !showAll}
            )
            .sheet(isPresented: Binding(get: { fillUpId != nil }, set: { if !$0 {fillUpId = nil}})){
                NavigationStack{
                    FillUpFormView(fillUpId: $fillUpId, vehicle: vehicle, onClose: closeModal)
                }
            }
        }
    }
    
    private func edit(id: FillUp.ID){
        fillUpId = id
    }
    
    private func closeModal(){
        fillUpId = nil
    }
}



//#Preview {
//    VehicleFillUpsCardView()
//}
