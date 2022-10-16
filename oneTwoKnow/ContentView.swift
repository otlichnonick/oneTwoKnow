//
//  ContentView.swift
//  oneTwoKnow
//
//  Created by Anton Agafonov on 16.10.2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var recognizerContent: RecognizedContent = .init()
    @State var showScanner: Bool = false
    @State var showAlert: Bool = false
    @State var isRecognizing = false
    @State var errorMessage: String = ""
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    List(recognizerContent.items) { textItem in
                        Text(String(textItem.text.prefix(50)).appending("..."))
                    }
                    
                    Button {
                        guard !isRecognizing else { return }
                        showScanner = true
                    } label: {
                        Text("Сканировать")
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                if isRecognizing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(uiColor: UIColor.systemIndigo)))
                }
            }
            .padding()
            .sheet(isPresented: $showScanner) {
                ScannerView(didCancelScanning: {
                    showScanner = false
                }, didFinishScanning: { result in
                    switch result {
                    case .success(let images):
                        isRecognizing = true
                        
                        TextRecognition(scannedImages: images,
                                        recognizedContent: recognizerContent) { isRecognizing = false }
                            .recognizeText()
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    }
                })
            }
            .alert("Ошибка. Не удалось сканировать", isPresented: $showAlert, actions: {}) {
                Text(errorMessage)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
