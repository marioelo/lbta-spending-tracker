//
//  AddCardForm.swift
//  Spending Tracker
//
//  Created by Mario Elorza on 25-09-22.
//

import SwiftUI

struct AddCardForm: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var cardName = ""
    @State private var cardNumber = ""
    @State private var creditLimit = ""
    @State private var cardType = "Visa"
    @State private var expirationMonth = 1
    @State private var expirationYear = 2022
    @State private var color = Color.blue
    
    private let currentYear = Calendar.current.component(.year, from: .now)
    
    var body: some View {
        NavigationView {
            Form {
                Section("CARD INFORMATION") {
                    TextField("Name", text: $cardName)
                    TextField("Credit Card Number", text: $cardNumber)
                        .keyboardType(.numberPad)
                    TextField("Credit Limit", text: $creditLimit)
                        .keyboardType(.numberPad)
                    Picker("Type", selection: $cardType) {
                        ForEach(["Visa", "Mastercard", "Discover"], id: \.self) { cardType in
                            Text(String(cardType)).tag(String(cardType))
                        }
                    }
                }
                
                Section("EXPIRATION") {
                    Picker("Month", selection: $expirationMonth) {
                        ForEach(1..<13, id: \.self) { num in
                            Text(String(num)).tag(String(num))
                        }
                    }
                    
                    Picker("Year", selection: $expirationYear) {
                        ForEach(currentYear..<currentYear + 20, id: \.self) { num in
                            Text(String(num)).tag(String(num))
                        }
                    }
                }
                
                Section("COLOR") {
                    ColorPicker("Color", selection: $color)
                }
                
            }
                .navigationTitle("Add Credit Card")
                .navigationBarItems(
                    leading: cancelButton,
                    trailing: saveButton)
        }
    }

    private var saveButton: some View {
        Button(action: {
            let card = Card(context: viewContext)
            card.name = cardName
            card.number = cardNumber
            card.limit = Int32(creditLimit) ?? 0
            card.expMonth = Int16(expirationMonth)
            card.expYear = Int16(expirationYear)
            card.timestamp = Date()
            card.color = UIColor(color).encode()
            
            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
        }, label: {
            Text("Save")
        })
    }

    private var cancelButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Cancel")
        })
    }
}

struct AddCardForm_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext
        AddCardForm().environment(\.managedObjectContext, viewContext)
    }
}

extension UIColor {
    class func color(data: Data) -> UIColor? {
        try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    }

    func encode() -> Data? {
        try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
}
