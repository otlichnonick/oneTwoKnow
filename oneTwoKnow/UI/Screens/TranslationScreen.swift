//
//  TranslationScreen.swift
//  oneTwoKnow
//
//  Created by Anton Agafonov on 22.10.2022.
//

import SwiftUI
import MLKit

struct TranslationScreen: View {
    private let locale = Locale.current
    private let modelManager = ModelManager.modelManager()
    private var allLanguages: [TranslateLanguage] {
        TranslateLanguage.allLanguages().sorted(by: { locale.localizedString(forLanguageCode: $0.rawValue) ?? "" < locale.localizedString(forLanguageCode: $1.rawValue) ?? "" })
    }
    @State private var selection = ""
    @State private var targetLanguage: TranslateLanguage = .russian
    @State private var sourceLanguage: TranslateLanguage = .croatian
    @State private var translatedText: String = ""
    @State private var alertMessage: String = ""
    @State private var alertTitle: String = ""
    @State private var showAlert: Bool = false
    @State private var showSheet: Bool = false
    @State private var showIndicator: Bool = false {
        didSet {
            withAnimation {
                blurRadius = showIndicator ? 7 : 0
            }
            disabled = showIndicator ? true : false
        }
    }
    @State private var indicatorTitle: String = ""
    @State private var onOkTapped: () -> Void = {}
    @State private var onCancelTapped: () -> Void = {}
    @State private var showCancelButton: Bool = false
    @State private var blurRadius: CGFloat = 0
    @State private var disabled: Bool = false
    @Binding var textToTranslate: String
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("выбран язык")
                    
                    Spacer()
                    
                    Button {
                        showSheet = true
                    } label: {
                        Text(locale.localizedString(forLanguageCode: targetLanguage.rawValue) ?? "")
                    }
                    .frame(height: 44)
                    .buttonStyle(.bordered)
                }
                
                ActionButton(title: "Перевести") {
                    tryTranslate()
                }
                
                ScrollView(showsIndicators: false) {
                    Text(translatedText)
                        .font(.body)
                }
                
                Spacer()
            }
            .padding()
            .blur(radius: blurRadius)
            .disabled(disabled)
            
            if showIndicator {
                VStack {
                    Text(indicatorTitle)
                        .font(.title)
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: CustomColors.mintGreen))
                }
            }
        }
        .sheet(isPresented: $showSheet, content: {
            SelectingLanguageView(selection: $selection,
                                  showSheet: $showSheet,
                                  allLanguages: allLanguages) {
                targetLanguage = allLanguages.first(where: { $0.rawValue == selection }) ?? .english
            }
        })
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK") {
                onOkTapped()
                showAlert = false
            }
            if showCancelButton {
                Button("Cancel") {
                    onCancelTapped()
                    showAlert = false
                }
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func remove(model: TranslateRemoteModel) {
        modelManager.deleteDownloadedModel(model) { error in
            guard error == nil else {
                showAlert(title: "Ошибка", message: "Не удалось удалить языковой пакет")
                return
            }
            
            showAlert = true
        }
    }
    
    private func translate() {
        let options = TranslatorOptions(sourceLanguage: sourceLanguage, targetLanguage: targetLanguage)
        let translator = Translator.translator(options: options)
        let conditions = ModelDownloadConditions(allowsCellularAccess: false, allowsBackgroundDownloading: true)
        showIndicator = true
        indicatorTitle = "Загружается языковая модель"
        
        translator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else {
                showAlert(title: "Ошибка", message: "Не удалось загрузить языковую модель", error: error?.localizedDescription)
                showIndicator = false
                return
            }
            
            indicatorTitle = "Выполняется перевод"
            translator.translate(textToTranslate) { text, error in
                guard error == nil else {
                    showAlert(title: "Ошибка", message: "Не удалось выполнить перевод", error: error?.localizedDescription)
                    showIndicator = false
                    return
                }
                
                translatedText = text ?? ""
                showIndicator = false
            }
        }
    }
    
    private func tryTranslate() {
        if checkLocalModelsContainSelected() {
            translate()
        } else {
            showCancelButton = true
            showAlert(title: "Внимание", message: "Чтобы выполнить перевод, необходимо скачать модель для выбранного языка")
            onOkTapped = {
                translate()
            }
        }
    }
    
    private func checkLocalModelsContainSelected() -> Bool {
        let localModels = modelManager.downloadedTranslateModels
        let model: TranslateRemoteModel = .translateRemoteModel(language: targetLanguage)
        return localModels.contains(model)
    }
}

extension TranslationScreen {
    private func showAlert(title: String, message: String, error: String? = nil) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}
