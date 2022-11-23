//
//  PickedImageCell.swift
//  oneTwoKnow
//
//  Created by Anton Agafonov on 16.10.2022.
//

import SwiftUI

struct PickedImageCell: View {
    let recognizedText: String
    let translatedText: String
    let image: Image
    
    var body: some View {
        
        HStack(alignment: .center) {
            image
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.size.width/3)
            
            VStack {
                Text(recognizedText)
                Text(translatedText)
            }
        }
    }
}
