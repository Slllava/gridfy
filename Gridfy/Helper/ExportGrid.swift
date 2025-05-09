//
//  ExportGrid.swift
//  Gridfy
//
//  Created by Viacheslav Kharkov on 13.04.2023.
//

import SwiftUI

struct ExportGrid {
    var state: UIState
    
    //----- SAVE PANEL
    func showSavePanel() -> URL? {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.png]
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.title = "Save your image"
        savePanel.message = "Choose a folder and a name to store the image."
        savePanel.nameFieldLabel = "Image file name:"
        
        let response = savePanel.runModal()
        return response == .OK ? savePanel.url : nil
    }
    
    //----- SAVE PNG
    func savePNG(imageName: NSImage, path: URL) {
        let image = imageName
        let imageRepresentation = NSBitmapImageRep(data: image.tiffRepresentation!)
        let pngData = imageRepresentation?.representation(using: .png, properties: [:])
        do {
            try pngData!.write(to: path)
        } catch {
            print(error)
        }
    }

    //----- EXPORT VIEW
    var exportView: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) { Rectangle().fill(.black.opacity(0.5)) }
            .frame(minWidth: CGFloat(state.params.marginWidth), maxWidth: CGFloat(state.params.marginWidth), minHeight: 0, maxHeight: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [tColor.main, tColor.second]), startPoint: .top, endPoint: .bottom))
            HStack(spacing: 0) {
                ForEach(state.params.columnItems, id: \.id) { i in
                    VStack(spacing: 0) {}
                    .frame(minWidth: CGFloat(state.calcResult("column").out), maxWidth: CGFloat(state.calcResult("column").out), minHeight: 0, maxHeight: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [tColor.main, tColor.second]), startPoint: .top, endPoint: .bottom))
                    .onAppear() {
                        print(i)
                    }
                    if i.number != state.params.columnItems.count {
                        HStack {}.frame(minWidth: CGFloat(state.params.gutterWidth), maxWidth: CGFloat(state.params.gutterWidth), minHeight: 0, maxHeight: .infinity)
                    }
                }
            }
            HStack(spacing: 0) { Rectangle().fill(.black.opacity(0.5)) }
            .frame(minWidth: CGFloat(state.params.marginWidth), maxWidth: CGFloat(state.params.marginWidth), minHeight: 0, maxHeight: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [tColor.main, tColor.second]), startPoint: .top, endPoint: .bottom))
        }
        .frame(height: 1080)
    }
}
