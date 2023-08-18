//
//  Constants.swift
//  openSouq
//
//  Created by Yousef Zuriqi on 18/08/2023.
//

import Foundation
import UIKit

struct Constants {
    static var isIpad = UITraitCollection.current.isIpad
    static var isEnglish = Locale.current.identifier == "en"
    static var noOfRows = isIpad ? 3 : 2
    static var spacing: CGFloat = isIpad ? 30 : 10
    static var edgeInsetSpacing: CGFloat = isIpad ? 30 : 10
    static var fontSize: CGFloat = isIpad ? 30 : 15
    static var customFont = (isEnglish ? UIFont(name: "Montserrat-Regular", size: isIpad ? 30 : 15) : UIFont(name: "GE Dinar One Medium", size: isIpad ? 30 : 18)) ?? .systemFont(ofSize: 18)
   
}
