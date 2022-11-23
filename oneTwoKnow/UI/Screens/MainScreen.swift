//
//  MainScreen.swift
//  oneTwoKnow
//
//  Created by Anton Agafonov on 22.11.2022.
//

import SwiftUI

struct MainScreen: View {
    @State var showScanner: Bool = false
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var isRecognizing = false
    @State var errorMessage: String = .init()
    @State var image: UIImage?
    @State var recognizedText: String = .init()
    @State var navLinkIsActive: Bool = false
    @State var showBottomButton: Bool = false
    @State var blurRadius: CGFloat = 0
    @State var showTextEditor: Bool = false
    @State var tempRecognizedText: String = .init()
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("text")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .blur(radius: blurRadius)
                
                VStack {
                    VStack(spacing: 30) {
                        HStack {
                            ActionButton(title: "Сделать фото",
                                    width: UIScreen.main.bounds.size.width * 0.45) {
                                guard !isRecognizing else { return }
                                sourceType = .camera
                                showScanner = true
                            }
                            
                            ActionButton(title: "Фото из галерее",
                                    width: UIScreen.main.bounds.size.width * 0.45) {
                                guard !isRecognizing else { return }
                                sourceType = .photoLibrary
                                showScanner = true
                            }
                        }
                    }
                    
                    ScrollView {
                        Text(recognizedText)
                            .foregroundColor(CustomColors.darkGray)
                    }
                    .padding(.horizontal, 16)
                    
                    if showBottomButton {
                        HStack {
                        ActionButton(title: "Редактировать текст",
                                width: UIScreen.main.bounds.size.width * 0.45) {
                            showTextEditor = true
                            tempRecognizedText = recognizedText
                        }
                        
                        ActionButton(title: "Перевести текст",
                                width: UIScreen.main.bounds.size.width * 0.45) {
                            navLinkIsActive = true
                        }
                        }
                    }
                }
                .padding()
                
                if isRecognizing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: CustomColors.mintGreen))
                        .frame(width: 100)
                }
            }
            .padding()
            .sheet(isPresented: $showScanner) {
                PhotoPicker(sourceType: $sourceType) { image in
                    TextRecognitionService(scannedImage: image,
                                    recognizedText: $recognizedText) {
                        isRecognizing = false
                        withAnimation {
                            showBottomButton = true
                            blurRadius = 5
                        }
                    }
                        .recognizeText()
                }
            }
            .sheet(isPresented: $showTextEditor) {
                TextEditorView(showTextEditor: $showTextEditor,
                               recognizedText: $recognizedText,
                               tempRecognizedText: $tempRecognizedText)
            }
            .background(
                NavigationLink(destination: TranslationScreen(textToTranslate: $recognizedText), isActive: $navLinkIsActive, label: {
                    EmptyView()
                })
            )
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
