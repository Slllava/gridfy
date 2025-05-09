//
//  ParamsMain.swift
//  Gridfy
//
//  Created by Slava on 30.04.2022.
//

import SwiftUI

struct ParametersItems: View  {
    @EnvironmentObject private var state: UIState
    @FocusState private var hasFocus: Bool
    
    var body: some View {

        HStack(alignment: .top, spacing: 10) {

            //----- PARAMETERS FIELDS
            Group() {
                ParamsFields()
            }.focused($hasFocus)
            
            //----- RESULT FIELDS
            ParamsResult()
            Spacer()

            VStack(alignment: .trailing, spacing: 0) {

                //----- RESET
                HStack {
                    ButtonSmall(action: {
                        state.startCaunter = true
                        state.params.columnItemsNum = 10
                        state.reset()
                        hasFocus = false
                    }, icon: "arrow.counterclockwise", secondIcon: "")
                    ButtonSmall(action: {
                        let export = ExportGrid(state: state)
                        let image = export.exportView.snapshot()
                        if let url = export.showSavePanel() {
                            export.savePNG(imageName: image!, path: url)
                        }
                    }, icon: "photo", secondIcon: "chevron.right")
                }
                Spacer()
        
                //----- GRAPHIC APP
                GraphicApp()
            }
        }
    }
}

/*------------------------------------------------
---- PARAMETERS FIELDS
------------------------------------------------*/

struct ParamsFields: View {
    @EnvironmentObject private var state: UIState
    
    //----- TIMER
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var counter = 1
    
    var body: some View {

        //----- BINDING
        let countColumns = Binding<Int>(get: {
            state.params.columnItemsNum
        }, set: { i in
            state.params.columnItemsNum = i
            state.startCaunter = true
        })

        VStack(spacing: 10) {
            //----- MAX WIDTH
            ParamsField("Max width", valueParams: $state.params.maxWidth)
            //----- COLUMN
            ParamsField("Columns", valueParams: countColumns, counter: counter)
                .onReceive(timer) { time in
                    if state.startCaunter == true {
                        counter = 2
                        state.startCaunter = false
                    }
                    if state.params.columnItemsNum != state.countItems() && counter == 0 {
                        state.countBinding(state.params.columnItemsNum)
                    }
                    if counter > -1 {
                        counter -= 1
                    }
                }
                .onSubmit {
                    counter = -1
                    state.startCaunter = false
                    state.countBinding(state.params.columnItemsNum)
                }
        }
        VStack(spacing: 10) {
            //----- GUTTER WIDTH
            ParamsField("Gutter width", valueParams: $state.params.gutterWidth)
            //----- MARGIN WIDTH
            ParamsField("Margin width", valueParams: $state.params.marginWidth)
        }
    }
}

/*------------------------------------------------
---- RESULT FIELDS
------------------------------------------------*/

struct ParamsResult: View {
    @EnvironmentObject private var state: UIState
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(spacing: 10) {
                //----- COLUMN WIDTH
                ResultField("Column width") {
                    Text(state.params.columnItems.count == 0 ? "0" : state.calcResult("column").outStr)
                    if !state.calcResult("column").isInt || !state.calcResult("column").isMinus {
                        Circle().fill(.red).frame(width: 6, height: 6)
                    }
                }.onChange(of: state.calcResult("column").outStr) { val in
                    state.setError(state.calcResult("column").isInt, "Column width is not an integer!")
                    state.setError(state.calcResult("column").isMinus, "Column width is less than 0!")
                }
                //----- PAGE WIDTH
                ResultField("Page width") {
                    Text(String(state.calcResult("page").outStr))
                    if state.calcResult("page").out < Float(state.params.maxWidth) || !state.calcResult("page").isInt || !state.calcResult("page").isMinus {
                        Circle().fill(.red).frame(width: 6, height: 6)
                    }
                }.onChange(of: state.calcResult("page").outStr) { val in
                    state.setError(val == String(state.params.maxWidth), "Width is not equal to your value!")
                }
            }
            ChangeVarResult()
        }
    }
}

/*------------------------------------------------
---- GRAPHICS
------------------------------------------------*/

struct GraphicApp: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 0) {
                Rectangle().frame(width: 1, height: 10).background(Color.white)
                Rectangle().frame(width: 160, height: 1).background(Color.white)
            }.opacity(0.15)
            Text("Grid Calculator")
                .font(.system(size: 12, weight: .regular, design: .monospaced))
                .opacity(0.6)
                .padding(.leading, 15)
            Image("Rule")
                .resizable()
                .frame(width: 191, height: 40)
                .padding(.top, 5)
                .shadow(color: Color(red: CGFloat(0.0/255.0), green: CGFloat(0.0/255.0), blue: CGFloat(0.0/255.0)).opacity(colorScheme == .dark ? 0.2 : 0.0), radius: 23, x: 0, y: 5)
        }.offset(x: 60, y: 0)
    }
}

/*------------------------------------------------
---- CHANGE VARIANT RESULT
------------------------------------------------*/

struct ChangeVarResult: View {
    @EnvironmentObject private var state: UIState
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            //----- LINE
            lineV(direction: "top")
            //----- BUTTON
            Button(action: {
                state.typeResult = state.typeResult == .page ? .column : .page
            }, label: {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(light: .black.opacity(0.8), dark: .white.opacity(0.8)))
                    .frame(minWidth: 30, minHeight: 30)
                    .background(.white.opacity(colorScheme == .dark ? 0.18 : 1))
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white.opacity(colorScheme == .dark ? 0.20 : 0), lineWidth: 1))
                    .shadow(color: .black.opacity(colorScheme == .dark ? 0 : 0.05), radius: 1, x: 0, y: 2)
                    .shadow(color: .black.opacity(colorScheme == .dark ? 0 : 0.06), radius: 10, x: 0, y: 5)
            })
            .buttonStyle(PlainButtonStyle())
            //----- LINE
            lineV(direction: "bottom")
        }
        .padding(.leading, 7)
        .opacity(state.errorInfo.name == "error" ? 1 : 0)
        .transition(.opacity)
        .animation(.easeInOut, value: state.errorInfo.name)
    }
}
