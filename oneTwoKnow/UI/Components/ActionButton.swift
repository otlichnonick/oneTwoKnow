//
//  ActionButton.swift
//  oneTwoKnow
//
//  Created by Anton Agafonov on 16.11.2022.
//

import SwiftUI

struct ActionButton: View {
    var title: String
    var width: CGFloat?
    var callback: () -> Void
    
    var body: some View {
        Button {
            callback()
        } label: {
            Text(title)
                .foregroundColor(CustomColors.darkGray)
                .padding(.horizontal, 25)
                .frame(width: width != nil ? width : nil, height: 44)
                .background(CustomColors.mintGreen)
                .cornerRadius(20)
        }
    }
}

struct XButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButton(title: "text", callback: {})
    }
}
