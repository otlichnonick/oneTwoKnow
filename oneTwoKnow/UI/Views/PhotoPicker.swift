//
//  PhotoPicker.swift
//  oneTwoKnow
//
//  Created by Anton Agafonov on 16.10.2022.
//

import Foundation
import SwiftUI
import VisionKit

struct PhotoPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    var handleImage: (UIImage) -> Void
    @Binding var sourceType: UIImagePickerController.SourceType
    
    init(sourceType: Binding<UIImagePickerController.SourceType>, handleImage: @escaping (UIImage) -> Void) {
        self.handleImage = handleImage
        _sourceType = sourceType
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: PhotoPicker
        
        init(parent: PhotoPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.handleImage(uiImage)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
}
