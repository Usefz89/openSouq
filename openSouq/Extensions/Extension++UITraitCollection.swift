//
//  Extension++UITraitCollection.swift
//  openSouq
//
//  Created by Yousef Zuriqi on 17/08/2023.
//

import Foundation
import UIKit

extension UITraitCollection {

    var isIpad: Bool {
        return horizontalSizeClass == .regular && verticalSizeClass == .regular
    }

    var isIphoneLandscape: Bool {
        return verticalSizeClass == .compact
    }

    var isIphonePortrait: Bool {
        return horizontalSizeClass == .compact && verticalSizeClass == .regular
    }

    var isIphone: Bool {
        return isIphoneLandscape || isIphonePortrait
    }
}
