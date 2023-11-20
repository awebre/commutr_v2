//
//  AddFillUpsView.swift
//  commutr_v2
//
//  Created by Austin Webre on 11/19/23.
//

import SwiftUI
import SwiftData

struct FillUpFormView: View {
    private enum Field {
        case date, distance, fuelAmount, pricePerFuelAmount
    }
    
    @Binding var fillUpId: FillUp.ID?
    var onClose: () -> Void
    
    @Environment(\.modelContext) private var modelContext
    @Query private var fillUps: [FillUp]
    
    @StateObject private var model = FillUpFormModel()
    @FocusState private var focusedField: Field?
    
    var body: some View {
        Form {
            Section(header: Text("Fill Up Information")){
                DatePicker("Date", selection: $model.date, displayedComponents: .date)
                    .focused($focusedField, equals: .date)
                HStack {
                    TextField("450.25", value: $model.distance, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .distance)
                    Text(model.distanceUnit == .miles ? "Miles" : "Kilometers")
                }.alignmentGuide(.listRowSeparatorLeading) {$0[.leading]}
                HStack {
                    TextField("$2.89", value: $model.pricePerFuelAmount, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .pricePerFuelAmount)
                    Text("$/Gallon")
                }.alignmentGuide(.listRowSeparatorLeading) {$0[.leading]}
                HStack {
                    TextField("16.739", value: $model.fuelAmount, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .fuelAmount)
                    Text(model.fuelUnit == .gallons ? "Gallons" : "Liters")
                }.alignmentGuide(.listRowSeparatorLeading) {$0[.leading]}
            }
            
            Section(header: Text("Stats")) {
                HStack {
                    Text("Total Cost: ")
                    Text("$\(String(describing: model.total))")
                }
                
                HStack {
                    Text("Fuel Economy: ")
                    Text("\(String(describing: model.fuelEconomy)) MPG")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(fillUpId != nil ? "Update Fill Up" : "Add New Fill Up")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", action: onClose)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save", action: save)
            }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Done", action: { focusedField = nil })
            }
        }
        .onAppear(){
            let fillUp = fillUps.first(where: { $0.id == fillUpId })
            ?? FillUp(date: Date.now, distance: nil, distanceUnit: .miles, fuelAmount: nil, fuelUnit: .gallons, pricePerFuelAmount: nil, priceUnit: .dollars, notes: "")
            model.id = fillUp.id
            model.date = fillUp.date ?? Date.now
            model.distance = fillUp.distance
            model.distanceUnit = fillUp.distanceUnit ?? .miles
            model.fuelAmount = fillUp.fuelAmount
            model.fuelUnit = fillUp.fuelUnit ?? .gallons
            model.pricePerFuelAmount = fillUp.pricePerFuelAmount
            model.priceUnit = fillUp.priceUnit ?? .dollars
            model.notes = fillUp.notes ?? ""
        }
    }
    
    private func save(){
        onClose()
    }
}

@Observable
class FillUpFormModel : ObservableObject {
    var id: FillUp.ID?
    var date = Date.now
    var distance: Decimal?
    var distanceUnit = DistanceUnit.miles
    var fuelAmount: Decimal?
    var fuelUnit = FuelUnit.gallons
    var pricePerFuelAmount: Decimal?
    var priceUnit = PriceUnit.dollars
    var notes = ""
    
    var total: Decimal {
        if let fuelAmount = self.fuelAmount,
           let price = self.pricePerFuelAmount {
            var result = fuelAmount * price
            var rounded = Decimal()
            NSDecimalRound(&rounded, &result, 2, .bankers)
            return rounded
        }
        return 0
    }
    
    var fuelEconomy: Decimal {
        if let fuelAmount = self.fuelAmount,
           let distance = self.distance {
            var result = fuelAmount != 0 ? distance / fuelAmount : 0
            var rounded = Decimal()
            NSDecimalRound(&rounded, &result, 2, .bankers)
            return rounded
        }
        
        return 0
    }
}

//#Preview {
//    FillUpFormView()
//}