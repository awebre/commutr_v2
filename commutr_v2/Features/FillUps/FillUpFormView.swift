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
    var vehicle: Vehicle
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
                Button("Cancel", systemImage: "xmark", action: onClose)
                    .foregroundColor(.accent)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if #available(iOS 26.0, *) {
                    Button("Save", systemImage: "checkmark", role: .confirm, action: save)
                        .foregroundColor(.accentText)
                } else {
                    Button("Save", systemImage: "checkmark", action: save)
                }

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
        if let existing = fillUps.first(where: { $0.id == fillUpId }){
            existing.date = model.date
            existing.distance = model.distance
            existing.distanceUnit = model.distanceUnit
            existing.fuelAmount = model.fuelAmount
            existing.fuelUnit = model.fuelUnit
            existing.pricePerFuelAmount = model.pricePerFuelAmount
            existing.priceUnit = model.priceUnit
            existing.notes = model.notes
        } else {
            let fillup = FillUp(
                date: model.date,
                distance: model.distance,
                distanceUnit: model.distanceUnit,
                fuelAmount: model.fuelAmount,
                fuelUnit: model.fuelUnit,
                pricePerFuelAmount: model.pricePerFuelAmount,
                priceUnit: model.priceUnit,
                notes: model.notes
            )
            fillup.vehicle = vehicle
            modelContext.insert(fillup)
        }
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
        return MathUtils.totalCost(fuelAmount: self.fuelAmount, pricePerFuelAmount: self.pricePerFuelAmount)
    }
    
    var fuelEconomy: Decimal {
        return MathUtils.fuelEconomy(fuelAmount: self.fuelAmount, distance: self.distance)
    }
}

//#Preview {
//    FillUpFormView()
//}
