//
//  AddFillUpButton.swift
//  commutr_v2
//
//  Created by Austin Webre on 11/21/23.
//

import SwiftUI

struct AddFillUpButton: View {
    var vehicle: Vehicle
    @State var isAdding = false
    var body: some View {
        Button(action: { isAdding = true }) {
            Text("Add Fill Up")
                .frame(maxWidth: .infinity)
                .padding()
        }
        .foregroundColor(.accentText)
        .background(.accent)
        .cornerRadius(10)
        .sheet(isPresented: $isAdding){
            NavigationStack{
                FillUpFormView(fillUpId: Binding.constant(nil), vehicle: vehicle, onClose: { isAdding = false })
            }
        }
    }
}

//#Preview {
//    AddFillUpButton()
//}
