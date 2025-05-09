//
//  ContentView.swift
//  Gridfy
//
//  Created by Slava on 26.04.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        //----- TITLE
        TitleBar()
        
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 15)  {
                //----- PREVIEW
                Preview()
                //----- PARAMETERS
                ParametersItems()
            }
            .padding(.horizontal, 30).padding(.top, 10).padding(.bottom, 30)
            
            //----- FOOTER
            FooterApp()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
