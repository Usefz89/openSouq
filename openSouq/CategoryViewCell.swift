//
//  CategoryViewCell.swift
//  openSouq
//
//  Created by Yousef Zuriqi on 17/08/2023.
//

import UIKit

class CategoryViewCell: UICollectionViewCell {
    
//    @IBOutlet weak var imageView: UIImageView!
//
//    @IBOutlet weak var label: UILabel!
    
    let myImageView: UIImageView = {
          let imageView = UIImageView()
          imageView.contentMode = .scaleAspectFit
          imageView.translatesAutoresizingMaskIntoConstraints = false
          return imageView
      }()
      
      let myLabel: UILabel = {
          let label = UILabel()
          label.textAlignment = .center
          label.translatesAutoresizingMaskIntoConstraints = false
          return label
      }()
      
      
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         setupViews()
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: .languageChanged, object: nil)
     }
      
      func setupViews() {
          addSubview(myImageView)
          myImageView.addSubview(myLabel)
          myLabel.textColor = .black
          myLabel.font = Constants.customFont
          
          NSLayoutConstraint.activate([
              myImageView.topAnchor.constraint(equalTo: topAnchor),
              myImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
              myImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
              myImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
              
              // Position the label inside the image view as needed
              myLabel.centerXAnchor.constraint(equalTo: myImageView.centerXAnchor),
              myLabel.centerYAnchor.constraint(equalTo: myImageView.centerYAnchor, constant: 70)
          ])
          
          // Add shadow
          layer.shadowColor = UIColor.black.cgColor // Shadow color
             layer.shadowOpacity = 0.5 // Shadow opacity
             layer.shadowOffset = CGSize(width: 0, height: 2) // Shadow offset
             layer.shadowRadius = 4 // Shadow radius
             layer.masksToBounds = false // Important to allow shadow to be drawn outside the bounds

             // Optional: Add a corner radius and set the shadow path for better performance
          
      }
    
    @objc func languageChanged() {
        setupViews()
    }
    
    
    
}
