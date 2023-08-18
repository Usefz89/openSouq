//
//  Extension++UIViewController.swift
//  openSouq
//
//  Created by Yousef Zuriqi on 17/08/2023.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showToast(message: String, font: UIFont) {
        let labelWidth: CGFloat = 200
        let labelXPosition = self.view.frame.size.width / 2 - labelWidth / 2
        let labelYPosition = self.view.frame.size.height - 100
        
        // Create a label to calculate the height
        let sizingLabel = UILabel()
        sizingLabel.font = font
        sizingLabel.text = message
        sizingLabel.numberOfLines = 0
        sizingLabel.lineBreakMode = .byWordWrapping
        let maxSize = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        let requiredSize = sizingLabel.sizeThatFits(maxSize)
        
        // Create the actual toast label
        let toastLabel = UILabel(frame: CGRect(x: labelXPosition, y: labelYPosition - requiredSize.height, width: labelWidth, height: requiredSize.height))
        toastLabel.adjustsFontSizeToFitWidth = true
        toastLabel.minimumScaleFactor = 0.5
        toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.numberOfLines = 0
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
