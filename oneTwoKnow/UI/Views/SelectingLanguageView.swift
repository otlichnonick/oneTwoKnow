//
//  SelectingLanguageView.swift
//  oneTwoKnow
//
//  Created by Anton Agafonov on 23.11.2022.
//

import SwiftUI
import MLKit

struct SelectingLanguageView: View {
    @Binding var selection: String
    @Binding var showSheet: Bool
    var allLanguages: [TranslateLanguage]
    var callback: () -> Void
    private let locale = Locale.current
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    showSheet = false
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(CustomColors.mintGreen)
                }

                Spacer()
                
                Button {
                    callback()
                    showSheet = false
                } label: {
                    Text("Сохранить")
                        .foregroundColor(CustomColors.mintGreen)
                }
            }
            
            Picker("", selection: $selection) {
                ForEach(allLanguages, id: \.self.rawValue) { lang in
                    Text(locale.localizedString(forLanguageCode: lang.rawValue) ?? "")
                        .foregroundColor(CustomColors.darkGray)
                }
            }
            .pickerStyle(.wheel)
            
            Spacer()
        }
        .padding()
        .background(CustomColors.lightGray)
    }
}
