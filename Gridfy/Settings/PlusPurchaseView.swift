//
//  PlusPurchaseView.swift
//  Gridfy
//
//  Created by Viacheslav Kharkov on 14.04.2023.
//

import SwiftUI
import StoreKit

struct PlusPurchaseView: View {
    let productIds = ["plus_version"]
    @State private var products: [Product] = []
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            //----- ELEMENT
            GridElGraphic()
            
            //----- CONTENT
            VStack(spacing: 20) {
                HStack {
                    Text("Plus")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    Text("+")
                        .font(.system(size: 18, weight: .regular))
                        .opacity(0.7)
                        .frame(width: 23, height: 23, alignment: .center)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(colorScheme == .dark ?  .white.opacity(0.15) : .black.opacity(0.15), lineWidth: 1))
                }
                Text("You can buy Plus version if you want to thank the developers. It includes five color themes.")
                    .font(.system(size: 14, weight: .regular)).multilineTextAlignment(.center).opacity(0.5)
                if purchaseManager.hasUnlockedPlus {
                    Text("Thank you for purchasing plus!")
                } else {
                    PurchaseButtons()
                }
            }.frame(minWidth: 0, maxWidth: .infinity).padding(.horizontal, 20)
            
            //----- ELEMENT
            GridElGraphic()
        }.task { do { try await purchaseManager.loadProducts() } catch { print(error) } }
    }
}

/*------------------------------------------------
---- GRAPHIC ELEMENT
------------------------------------------------*/

struct GridElGraphic: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(spacing: 5) {
            VStack(spacing: 5) {
                Rectangle().fill(LinearGradient(gradient: Gradient(colors: [.white.opacity(0), colorScheme == .dark ? .white.opacity(0.25) : Color.white.opacity(1.0)]), startPoint: .top, endPoint: .bottom))
                    .frame(width: 50, height: 100)
                    .cornerRadius(5)
                Rectangle().fill(LinearGradient(gradient: Gradient(colors: [colorScheme == .dark ? .white.opacity(0.05) : Color.white.opacity(0.4), .white.opacity(0)]), startPoint: .top, endPoint: .bottom))
                    .frame(width: 50, height: 100)
                    .cornerRadius(5)
            }
            VStack(spacing: 5) {
                Rectangle().fill(LinearGradient(gradient: Gradient(colors: [.white.opacity(0), colorScheme == .dark ? .white.opacity(0.25) : Color.white.opacity(1.0)]), startPoint: .top, endPoint: .bottom))
                    .frame(width: 50, height: 100)
                    .cornerRadius(5)
                Rectangle().fill(LinearGradient(gradient: Gradient(colors: [colorScheme == .dark ? .white.opacity(0.05) : Color.white.opacity(0.4), .white.opacity(0)]), startPoint: .top, endPoint: .bottom))
                    .frame(width: 50, height: 100)
                    .cornerRadius(5)
            }
            .offset(y: 25)
        }
    }
}

/*------------------------------------------------
---- PURCHASE BUTTONS
------------------------------------------------*/

struct PurchaseButtons: View {
    @EnvironmentObject private var purchaseManager: PurchaseManager

    var body: some View {
        //----- BUY
        ForEach(purchaseManager.products) { (product) in
            HStack(spacing: 20) {
                Button( action: {
                    Task { do { try await purchaseManager.purchase(product) } catch { print(error) } }
                }, label: { Text("Unlock")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .background(LinearGradient(gradient: Gradient(colors: [Color("MainBlue"), Color("SecondBlue")]), startPoint: .top, endPoint: .bottom))
                    .overlay(Rectangle().stroke(Color.white.opacity(0.3), lineWidth: 5).blur(radius: 3)) }).buttonStyle(PlainButtonStyle())
                    .cornerRadius(10)
                Text(product.displayPrice).font(.system(size: 16, weight: .semibold, design: .monospaced))
            }
        }
        
        //----- RESTORE
        Button {
            Task { do { try await AppStore.sync() } catch { print(error) } }
        } label: {
            Text("Restore Purchases").opacity(0.5).padding(.top, 20)
        }.buttonStyle(PlainButtonStyle())
    }
}
