//
//  RecognizedContent.swift
//  oneTwoKnow
//
//  Created by Anton Agafonov on 16.10.2022.
//

import Foundation
import SwiftUI

final class RecognizedContent: ObservableObject {
    @Published var items: [TextItem] = .init()
}
