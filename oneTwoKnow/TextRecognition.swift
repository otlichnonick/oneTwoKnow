//
//  TextRecognition.swift
//  oneTwoKnow
//
//  Created by Anton Agafonov on 16.10.2022.
//

import SwiftUI
import Vision

struct TextRecognition {
    var scannedImages: [UIImage]
    @ObservedObject var recognizedContent: RecognizedContent
    var didFinishRecognition: () -> Void
    
    func recognizeText() {
        let queue = DispatchQueue(label: "textecognitionQueue", qos: .userInitiated)
        queue.async {
            scannedImages.forEach { image in
                guard let cgImage = image.cgImage else { return }
                let requestHandler = VNImageRequestHandler(cgImage: cgImage)
                
                do {
                    let textItem = TextItem()
                    try requestHandler.perform([getTextRecognitionRequest(with: textItem)])
                    
                    DispatchQueue.main.async {
                        recognizedContent.items.append(textItem)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            DispatchQueue.main.async {
                didFinishRecognition()
            }
        }
    }
    
    private func getTextRecognitionRequest(with textItem: TextItem) -> VNRecognizeTextRequest {
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            observations.forEach { observation in
                guard let recognizedText = observation.topCandidates(1).first else { return }
                
                textItem.text += recognizedText.string
                textItem.text += "\n"
            }
        }
        
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        return request
    }
}
