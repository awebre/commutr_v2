//
//  FillUpsTopThree.swift
//  commutr_v2
//
//  Created by Austin Webre on 11/20/23.
//

import SwiftUI
import SwiftData

struct FillUpsTopThree: View {
    @Environment(\.modelContext) private var modelContext

    @Query private var topThree: [FillUp]
    var edit: (FillUp.ID) -> Void
    
    @State var confirmDelete = false
    
    init(vehicleId: Vehicle.ID, edit: @escaping (FillUp.ID) -> Void){
        let predicate = #Predicate<FillUp> {
            $0.vehicle?.persistentModelID == vehicleId &&
            $0.date != nil
        }
        var descriptor = FetchDescriptor<FillUp>(predicate: predicate,
                                                 sortBy: [SortDescriptor(\.date, order: .reverse)])
        descriptor.fetchLimit = 3
        
        _topThree = Query(descriptor)
        self.edit = edit
    }
    
    var body: some View {
        List(topThree) { fillUp in
            HStack {
                if let date = fillUp.date{
                    Text(date, style: .date)
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
    
    private func delete() {
        confirmDelete = true
    }
    
    private func confirmDeleteItem(id: FillUp.ID) {
        if let fillUp = topThree.first(where: { $0.id == id }){
            modelContext.delete(fillUp)
        }
        confirmDelete = false
    }
    
    private func cancelDelete() {
        confirmDelete = false
    }
}

//#Preview {
//    FillUpsTopThree()
//}
