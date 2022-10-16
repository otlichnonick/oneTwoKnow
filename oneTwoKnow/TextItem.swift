//
//  TextItem.swift
//  oneTwoKnow
//
//  Created by Anton Agafonov on 16.10.2022.
//

import Foundation

final class TextItem: Identifiable {
    var id: String = UUID().uuidString
    var text: String = ""
}
