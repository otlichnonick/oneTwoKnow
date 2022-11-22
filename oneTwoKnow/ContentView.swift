//
//  ContentView.swift
//  oneTwoKnow
//
//  Created by Anton Agafonov on 16.10.2022.
//

import SwiftUI

struct ContentView: View {
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
                            XButton(title: "Сделать фото",
                                    width: UIScreen.main.bounds.size.width * 0.45) {
                                guard !isRecognizing else { return }
                                sourceType = .camera
                                showScanner = true
                            }
                            
                            XButton(title: "Фото из галерее",
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
                        XButton(title: "Редактировать текст",
                                width: UIScreen.main.bounds.size.width * 0.45) {
                            showTextEditor = true
                            tempRecognizedText = recognizedText
                        }
                        
                        XButton(title: "Перевести текст",
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
                    TextRecognition(scannedImage: image,
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
                VStack {
                    HStack {
                        Button {
                            showTextEditor = false
                        } label: {
                            Image(systemName: "arrow.backward")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(CustomColors.mintGreen)
                                .frame(width: 24)
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
            .background(
                NavigationLink(destination: TranslationScreen(textToTranslate: $recognizedText), isActive: $navLinkIsActive, label: {
                    EmptyView()
                })
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
