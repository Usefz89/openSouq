//
//  LanguageManager.swift
//  openSouq
//
//  Created by Yousef Zuriqi on 19/08/2023.
//

import Foundation

class LanguageManager {
    static let shared = LanguageManager()
    var currentLanguage: String = "en" {
        didSet {
            NotificationCenter.default.post(name: .languageChanged, object: nil)
        }
    }
    
    func setLanguage() {
        currentLanguage = currentLanguage == "en" ? "ar" : "en"
        NotificationCenter.default.post(name: Notification.Name("languageChanged"), object: nil)
    }
}

extension NSNotification.Name {
    static let languageChanged = NSNotification.Name("languageChanged")
}

