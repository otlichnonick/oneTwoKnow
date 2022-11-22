//
//  TextTranslation.swift
//  oneTwoKnow
//
//  Created by Anton Agafonov on 22.10.2022.
//

import Foundation
import MLKit

struct TextTranslation {
    private let locale = Locale.current
    lazy var allLanguages = TranslateLanguage.allLanguages().sorted {
        return locale.localizedString(forLanguageCode: $0.rawValue)!
          < locale.localizedString(forLanguageCode: $1.rawValue)!
    }
}
