//
//  FillUpsTopThree.swift
//  commutr_v2
//
//  Created by Austin Webre on 11/20/23.
//

import SwiftUI
import SwiftData

struct FillUpsListView: View {
    @Environment(\.modelContext) private var modelContext

    @Query private var fillUps: [FillUp]
    var edit: (FillUp.ID) -> Void
    var onToggleShowAll: () -> Void
    var showAll: Bool
    
    @State var confirmDelete = false
    
    init(vehicleId: Vehicle.ID, 
         showAll: Bool,
         edit: @escaping (FillUp.ID) -> Void,
         onToggleShowAll: @escaping () -> Void
    ){
        let predicate = #Predicate<FillUp> {
            $0.vehicle?.persistentModelID == vehicleId &&
            $0.date != nil
        }
        var descriptor = FetchDescriptor<FillUp>(predicate: predicate,
                                                 sortBy: [SortDescriptor(\.date, order: .reverse)])
        
        if(!showAll) {
            descriptor.fetchLimit = 3
        }
        
        _fillUps = Query(descriptor)
        self.edit = edit
        self.onToggleShowAll = onToggleShowAll
        self.showAll = showAll
    }
    
    var body: some View {
        List {
            Section(footer: SeeMoreButton(showAll: showAll, onToggleShowAll: onToggleShowAll, hideButton: fillUps.count <= 3)) {
                ForEach(fillUps) { fillUp in
                    VStack {
                        HStack {
                            if let date = fillUp.date{
                                Text(date, style: .date)
                                    .font(.title3)
                                Spacer()
                            }
                            Text("\(String(describing: fillUp.fuelEconomy)) MPG")
                                .font(.title3)
                        }.padding(.bottom, 5)
                        HStack {
                            if let distance = fillUp.distance,
                               let distanceUnit = fillUp.distanceUnit {
                                Text("\(String(describing: distance)) \(distanceUnit == .miles ? "mi" : "km")")
                                    .font(.subheadline)
                                Spacer()
                            } else {
                                EmptyView()
                            }
                            
                            Text(fillUp.total, format: .currency(code: "USD"))
                                .font(.subheadline)
                        }
                    }
                    .swipeActions(edge: .trailing){
                        Button(){
                            edit(fillUp.id)
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }.tint(.accent)
                    }
                    .swipeActions(edge: .leading){
                        Button(){
                            delete()
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }.tint(.red)
                    }
                    .confirmationDialog("Delete this fill up?", isPresented: $confirmDelete) {
                        Button("Delete this fill up?",
                               role: .destructive,
                               action: { confirmDeleteItem(id: fillUp.id) })
                        Button("Cancel", role: .cancel, action: cancelDelete)
                    }
                }
            }
        }.animation(.smooth, value: showAll)

    }
    
    private func delete() {
        confirmDelete = true
    }
    
    private func confirmDeleteItem(id: FillUp.ID) {
        if let fillUp = fillUps.first(where: { $0.id == id }){
            modelContext.delete(fillUp)
        }
        confirmDelete = false
    }
    
    private func cancelDelete() {
        confirmDelete = false
    }
}

struct SeeMoreButton: View {
    var showAll: Bool
    var onToggleShowAll: () -> Void
    var hideButton = false

    var body: some View {
        if(hideButton){
            EmptyView()
        } else {
            HStack(){
                Spacer()
                Button("See \(showAll ? "Less" : "More")", action: onToggleShowAll)
                Spacer()
            }
        }
    }
}

//#Preview {
//    FillUpsTopThree()
//}
