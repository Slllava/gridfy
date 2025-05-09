//
//  SettingsMain.swift
//  Gridfy
//
//  Created by Slava on 23.06.2022.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var params = UIState()

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 15) {
                Text("Preferences")
                    .font(.system(size: 16, weight: .regular))
                    .opacity(0.7)
                Divider()
                OptionsView()
                Divider().padding(.top, 5)
                FooterOptionsView()
            }
            .padding(35)
            Spacer()
            Group { Image(SettingsImg())
                .resizable()
                .frame(width: 195, height: 175)
                .offset(y: -10)
            }
            .frame(minWidth: 200, minHeight: 0, maxHeight: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [tColor.main, tColor.second]), startPoint: .top, endPoint: .bottom))
            
        }
    }
    
    //----- SETTING IMG
    func SettingsImg() -> String {
        if(params.colorTheme == .purple) {
            return "SettingsImgPurple"
        } else if(params.colorTheme == .red) {
            return "SettingsImgRed"
        } else if(params.colorTheme == .yellow) {
            return "SettingsImgYellow"
        } else if(params.colorTheme == .green) {
            return "SettingsImgGreen"
        } else {
            return "SettingsImg"
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
