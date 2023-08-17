//
//  CategoriesCollectionViewController.swift
//  openSouq
//
//  Created by Yousef Zuriqi on 17/08/2023.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "Cell"

class CategoriesViewController: UICollectionViewController {
    
    let requestManager = RequestManager()
    var categories: [Category] = []
    var request: RequestProtocol = RequestCategory()
    let isEnglish = Locale.current.languageCode == "en"
    let traitCollections = UITraitCollection.current


    
    lazy var columnLayout = CategoriesViewFlowLayout(
        cellsPerRow: traitCollection.isIpad ? 3 : 2 ,
          minimumInteritemSpacing: 10,
          minimumLineSpacing: 10,
          sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
      )
    
    @IBOutlet weak var langButton: UIBarButtonItem!
    
    @IBAction func tapLangButton(_ sender: UIBarButtonItem) {
        changeLanguageInterface()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change the status bar color to match the navigation bar
        customizeNavigationBar()
        
        // Customize the collectionView
        collectionView?.collectionViewLayout = columnLayout
        collectionView?.contentInsetAdjustmentBehavior = .always
//        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        // Fetch the data
        Task {
            await fetchData(request: request)
        }
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryViewCell
    
        // Configure the cell
        let category = categories[indexPath.row]
        
        //kf image proccesing
        let url = URL(string: category.picture)
        let processor = DownsamplingImageProcessor(size: cell.imageView.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 20)
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(0.5)),
                .cacheOriginalImage
            ])
       
        
        //Set label
        cell.label.text = "\(isEnglish ?  category.nameEn : category.nameAr) (\(category.subProductCategoriesCount))"
        
        
        let arabicFont = UIFont(name: "GE Dinar One Medium", size: traitCollections.isIpad ? 30 : 18)
        let englishFont = UIFont(name: "Montserrat-Regular", size: traitCollections.isIpad ? 30 : 18)
        
        
        cell.label.font = isEnglish ? englishFont : arabicFont
        
       
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let categoriesVC = storyboard.instantiateViewController(withIdentifier: "CategoriesVC") as! CategoriesViewController
        let category = categories[indexPath.row]
        let categoryID = category.productCategoryId
        let request = RequestSubCategory(categoryID: categoryID)
        categoriesVC.request = request
        
        if !category.isLastChild || category.subProductCategoriesCount != 0  {
            navigationController?.pushViewController(categoriesVC, animated: true)
        } else {
            self.showToast(message: "Your Toast Message", font: .systemFont(ofSize: 12.0))
            
        }
    }
        
    //Make customization for the navigation bar
    func customizeNavigationBar() {
        if let navigationController = navigationController,
           let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let statusBarFrame = windowScene.statusBarManager?.statusBarFrame {
            let statusBarView = UIView(frame: statusBarFrame)
            statusBarView.backgroundColor = navigationController.navigationBar.backgroundColor
            view.addSubview(statusBarView)
            
            // Add image to the navigation bar
            let image = UIImage(named: "top_bar_logo")
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            navigationItem.titleView = imageView
            
            // Add back button image
            self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backImage")
                self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backImage")
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
            
            //Language Button configaration
            if isEnglish {
                langButton.title = "عربي"

            } else {
                langButton.title = "English"
            }
            
            langButton.tintColor = .white
    
        }
    }
    
    // Change the language interface
    func changeLanguageInterface() {
        let currentLanguage = Locale.current.languageCode
        let selectedLanguage = currentLanguage == "en" ? "ar" : "en"
        UserDefaults.standard.set([selectedLanguage], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // Make alert
        let alert = UIAlertController(title: NSLocalizedString("alertTitle", comment: ""), message: NSLocalizedString("alertDescription", comment: ""), preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default))
        self.present(alert, animated: true, completion: nil)

    }
    

    
    //Fetch data from API
    func fetchData(request: RequestProtocol) async  {
        do {
          
            let decodedData: [Category] = try await requestManager.perform(request: request)
            categories = decodedData
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } catch {
            
        }
        
    }

}
