//
//  MainView.swift
//  Spending Tracker
//
//  Created by Mario Elorza on 31-07-22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                TabView {
                    ForEach(0..<5) { index in
                        CreditCardView()
                            .padding(.bottom, 50)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 240)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            }
            .navigationTitle("Credit Cards")
            .navigationBarItems(trailing: addCardButton)
        }
    }
    
    struct CreditCardView: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text("Apple Blue Visa Card")
                    .font(.system(size: 24, weight: .semibold))
                
                HStack {
                    Image("visa")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 44)
                    Spacer()
                    Text("Balance: $5.000")
                        .font(.system(size: 18, weight: .semibold))
                }
                
                Text("1234 1234 1234 1234")
                
                Text("Credit Limit: $50.000")
                
            }
            .foregroundColor(.white)
            .padding()
            .background(
                LinearGradient(colors: [Color.blue.opacity(0.6), Color.blue], startPoint: .center, endPoint: .bottom)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.5), lineWidth: 1)
            )
            .cornerRadius(8)
            .shadow(radius: 5)
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }
    
    var addCardButton: some View {
        Button(action: {
            print("Test")
        }, label: {
            Text("+ Card")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold))
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                .background(Color.black)
                .cornerRadius(5)
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
