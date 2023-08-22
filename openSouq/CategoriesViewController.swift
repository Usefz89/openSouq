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
    var languageManager = LanguageManager.shared
    

    lazy var columnLayout = CategoriesViewFlowLayout(
        cellsPerRow: Constants.noOfRows,
        minimumInteritemSpacing: Constants.spacing,
        minimumLineSpacing: Constants.spacing,
        sectionInset: UIEdgeInsets(
            top: Constants.edgeInsetSpacing,
            left: Constants.edgeInsetSpacing,
            bottom: Constants.edgeInsetSpacing,
            right: Constants.edgeInsetSpacing
        )
      )
    
    @IBOutlet weak var langButton: UIBarButtonItem!
    @IBAction func tapLangButton(_ sender: UIBarButtonItem) {
        changeLanguageInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.overrideUserInterfaceStyle = .light
        // Change the status bar color to match the navigation bar
        customizeNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: .languageChanged, object: nil)

        // Customize the collectionView
        collectionView?.collectionViewLayout = columnLayout
        collectionView?.contentInsetAdjustmentBehavior = .always
        // Fetch the data
        Task { await fetchData(request: request) }
    }
    
    // change langbutton language and reload collectionview data
    @objc func languageChanged() {
        self.langButton.title = localizedString(for: "langButton")
        collectionView.reloadData()
        
    }
    
    // use localized string to chagne language
    func localizedString(for key: String) -> String {
        let language = LanguageManager.shared.currentLanguage
        
        if let path = Bundle.main.path(forResource: language, ofType: "lproj"), let bundle = Bundle(path: path) {
            return NSLocalizedString(key, bundle: bundle, comment: "")
        } else {
            return NSLocalizedString(key, comment: "")
        }
       
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryViewCell
    
        // Get the category
        let category = categories[indexPath.row]
        
        //kf image fetching
        let url = URL(string: category.picture)
        // modify the placeholerimage
        
        cell.imageView.kf.indicatorType = .activity
        cell.imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "cat_no_img")
        )
        
        

        

        // Remove the spaces at end of string.
        let name = category.nameByLang.trimmingCharacters(in: .whitespaces)
        cell.label.text = "\(name) (\(category.subProductCategoriesCount))".capitalized
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //prepare the vc to navigate to
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let categoriesVC = storyboard.instantiateViewController(withIdentifier: "CategoriesVC") as! CategoriesViewController
        let category = categories[indexPath.row]
        let categoryID = category.productCategoryId
        let request = RequestSubCategory(categoryID: categoryID)
        categoriesVC.request = request
        
        //navigate if is not the last category
        if !category.isLastChild || category.subProductCategoriesCount != 0  {
            categoriesVC.title = category.nameByLang

            let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
            categoriesVC.navigationController?.navigationBar.titleTextAttributes = textAttributes
            navigationController?.pushViewController(categoriesVC, animated: true)
        } else {
            //show toast msg if it's last child
            self.showToast(message: localizedString(for: "lastCategory"), font: Constants.customFont)
        }
        print(category.productCategoryId)
    }
        
    //Make customization to the Navigation bar
    func customizeNavigationBar() {
        
        // Extend the navigation bar color to status bar
        if let navigationController = navigationController,
           let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let statusBarFrame = windowScene.statusBarManager?.statusBarFrame {
            let statusBarView = UIView(frame: statusBarFrame)
            statusBarView.backgroundColor = navigationController.navigationBar.backgroundColor
            view.addSubview(statusBarView)
            
            // Add image to the navigation if it's the first viewController
            if self == navigationController.viewControllers.first {
                let image = UIImage(named: "top_bar_logo")
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                navigationItem.titleView = imageView
                langButton.title = localizedString(for: "langButton")
                langButton.tintColor = .white
            }else {
                navigationItem.titleView = nil
                navigationItem.setRightBarButton(nil, animated: true)
            }
           
            //Language Button configaration
           
        }
    }
    
    // Change the language interface
    func changeLanguageInterface() {
        languageManager.setLanguage()
        collectionView.reloadData()
        print(LanguageManager.shared.currentLanguage)
        
//        let currentLanguage = Locale.current.languageCode
//        let selectedLanguage = currentLanguage == "en" ? "ar" : "en"
//        UserDefaults.standard.set([selectedLanguage], forKey: "AppleLanguages")
//        UserDefaults.standard.synchronize()
//
//        // Make alert
//        let alert = UIAlertController(
//            title: localizedString(for: "alertTitle"),
//            message: localizedString(for: "alertDescription"),
//            preferredStyle: .alert
//        )
//        // Add alert action
//        alert.addAction(UIAlertAction(title: localizedString(for: "ok"), style: .default) {_ in
//            self.collectionView.reloadData()
//        })
//        self.present(alert, animated: true, completion: nil)
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
            print("Error: \(error.localizedDescription)")
        }
    }
}
