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
        if #available(iOS 26.0, *) {
            Button("Add Fill Up", systemImage: "plus", role: .confirm) {
                isAdding = true
            }
            .foregroundColor(.accentText)
            .background(.accent)
            .cornerRadius(10)
            .sheet(isPresented: $isAdding){
                NavigationStack{
                    FillUpFormView(fillUpId: Binding.constant(nil), vehicle: vehicle, onClose: { isAdding = false })
                }
            }
        } else {
            Button(action: { isAdding = true }) {
                Text("Add Fill Up")
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
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
}

//#Preview {
//    AddFillUpButton()
//}
