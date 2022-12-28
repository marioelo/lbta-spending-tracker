//
//  MainView.swift
//  Spending Tracker
//
//  Created by Mario Elorza on 31-07-22.
//

import SwiftUI

struct MainView: View {
    
    @State private var shouldPresentAddCardForm = false
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)],
        animation: .default)
    private var cards: FetchedResults<Card>
    
    var body: some View {
        NavigationView {
            ScrollView {
                if !cards.isEmpty {
                    TabView {
                        ForEach(cards) { card in
                            CreditCardView(card: card)
                                .padding(.bottom, 50)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(height: 260)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                } else {
                    emptyPromtView
                }
                
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentAddCardForm) {
                        AddCardForm()
                    }
            }
            .navigationTitle("Credit Cards")
            .navigationBarItems(
                leading: HStack {
                    addItemButton
                    deleteAllButton
                },
                trailing: addCardButton)
        }
    }
    
    private var emptyPromtView: some View {
        VStack {
            Text("You currently have no Cards in the system")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 48)
                .padding(.vertical)
                
            Button {
                shouldPresentAddCardForm.toggle()
            } label: {
                Text("+ Add your first card")
                    .foregroundColor(Color(.systemBackground))
            }
            .padding(.init(top: 10, leading: 14, bottom: 10, trailing: 14))
            .background(Color(.label))
            .cornerRadius(5)
            
        }.font(.system(size: 24, weight: .semibold))
    }
    
    struct CreditCardView: View {
        
        let card: Card
        
        @State private var shouldShowDialog = false
        @State private var shouldShowEditForm = false
        @State var refreshID = UUID()
        
        private func handleDelete() {
            let viewContext = PersistenceController.shared.container.viewContext
            viewContext.delete(card)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        
        var cardColor: Color {
            guard
                let colorData = card.color,
                let uiColor = UIColor.color(data: colorData)
            else {
                return .cyan
            }
            return Color(uiColor: uiColor)
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(card.name ?? "")
                        .font(.system(size: 24, weight: .semibold))
                    
                    Spacer()
                    
                    Button {
                        shouldShowDialog.toggle()
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 24,weight: .bold))
                    }
                    .actionSheet(isPresented: $shouldShowDialog) {
                        .init(title: Text(card.name ?? ""), message: Text("Options"), buttons: [
                            .default(Text("Edit"), action: {
                                shouldShowEditForm.toggle()
                            }),
                            .destructive(Text("Delete"), action: handleDelete),
                            .cancel()
                        ])
                    }
                }
                
                HStack {
                    Image(card.type?.lowercased() ?? "visa")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 44)
                    Spacer()
                    Text("Balance: $5.000")
                        .font(.system(size: 18, weight: .semibold))
                }
                
                Text(card.number ?? "")
                
                Text("Credit Limit: $\(card.limit)")
                
            }
            .foregroundColor(.white)
            .padding()
            .background(
                LinearGradient(colors: [cardColor.opacity(0.6), cardColor], startPoint: .center, endPoint: .bottom)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.5), lineWidth: 1)
            )
            .cornerRadius(8)
            .shadow(radius: 5)
            .padding(.horizontal)
            .padding(.top, 8)
            
            .fullScreenCover(isPresented: $shouldShowEditForm) {
                AddCardForm(card: card)
            }
        }
    }
    
    var addCardButton: some View {
        Button(action: {
            shouldPresentAddCardForm.toggle()
        }, label: {
            Text("+ Card")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold))
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                .background(Color.black)
                .cornerRadius(5)
        })
    }
    
    var addItemButton: some View {
        Button(action: {
            withAnimation {
                let card = Card(context: viewContext)
                card.timestamp = Date()

                do {
                    try viewContext.save()
                } catch {
                    
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }, label: {
            Text("Add Item")
        })
    }
    
    var deleteAllButton: some View {
        Button(action: {
            withAnimation {
                cards.forEach { viewContext.delete($0) }

                do {
                    try viewContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }, label: {
            Text("Delete All")
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext
        MainView().environment(\.managedObjectContext, viewContext)
    }
}
