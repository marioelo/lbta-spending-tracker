//
//  AdTransaction.swift
//  Spending Tracker
//
//  Created by Mario Elorza on 28-12-22.
//

import SwiftUI

struct AdTransactionForm: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var amount = ""
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Information")) {
                    TextField("Name", text: $name)
                    TextField("Amount", text: $amount)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    NavigationLink {
                        Text("New category page")
                            .navigationTitle("New Title")
                    } label: {
                        Text("Many to many")
                    }

                }
                
                Section(header: Text("Photo/Receipt")) {
                    Button {
                        
                    } label: {
                        Text("Select Photo")
                    }

                }
            }
            .navigationTitle("Add Transaction")
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
        }
        
    }
    
    private var saveButton: some View {
        Button {
            
        } label: {
            Text("Save")
        }
    }
    
    private var cancelButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Cancel")
        }
    }
}

struct AdTransaction_Previews: PreviewProvider {
    static var previews: some View {
        AdTransactionForm()
    }
}
