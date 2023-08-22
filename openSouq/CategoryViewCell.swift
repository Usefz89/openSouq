//
//  CategoryViewCell.swift
//  openSouq
//
//  Created by Yousef Zuriqi on 17/08/2023.
//

import UIKit

class CategoryViewCell: UICollectionViewCell {
    
    
    let imageView: UIImageView = {
          let imageView = UIImageView()
          imageView.contentMode = .scaleAspectFit
          imageView.translatesAutoresizingMaskIntoConstraints = false
          return imageView
      }()
    
    let shadowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "shadow")
        return imageView
        
    }()
      
      let label: UILabel = {
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
          addSubview(imageView)
          imageView.addSubview(shadowImageView)
          imageView.addSubview(label)
          label.textColor = .white
          label.font = Constants.customFont
          label.numberOfLines = 0
                    
          NSLayoutConstraint.activate([
              imageView.topAnchor.constraint(equalTo: topAnchor),
              imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
              imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
              imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
              
              // Position the label inside the image view as needed
              label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
              label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: 70),
              label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
              label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor)
          ])
          

          
      }
    
    @objc func languageChanged() {
        setupViews()
    }
    
    
    
}
