//
//  TextEditorView.swift
//  oneTwoKnow
//
//  Created by Anton Agafonov on 22.11.2022.
//

import SwiftUI

struct TextEditorView: View {
    @Binding var showTextEditor: Bool
    @Binding var recognizedText: String
    @Binding var tempRecognizedText: String
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    showTextEditor = false
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(CustomColors.mintGreen)
                }
                
                Spacer()
                
                Button {
                    recognizedText = tempRecognizedText
                    showTextEditor = false
                } label: {
                    Text("Сохранить")
                        .foregroundColor(CustomColors.mintGreen)
                }

            }
            
            if #available(iOS 16.0, *) {
                TextEditor(text: $tempRecognizedText)
                    .foregroundColor(CustomColors.darkGray)
                    .scrollContentBackground(.hidden)
                    .background(CustomColors.lightGray)
            } else {
                TextEditor(text: $tempRecognizedText)
                    .foregroundColor(CustomColors.darkGray)
                    .background(CustomColors.lightGray)
            }
        }
        .padding(.all)
        .background(CustomColors.lightGray)
    }
}

struct TextEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorView(showTextEditor: .constant(true), recognizedText: .constant(""), tempRecognizedText: .constant(""))
    }
}
