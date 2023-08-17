//
//  RequestCategory.swift
//  openSouq
//
//  Created by Yousef Zuriqi on 17/08/2023.
//

import Foundation



enum RequestCategoryEnum: RequestProtocol {
    case category
    case subCategory(categoryID: Int)
    
    var path: String {
        switch self {
        case .category:
            return "ParentCategories/"
        case .subCategory:
            return "SubCategories/"
        }
    }
    
    var requestType: RequestType {
        return RequestType.GET
    }
    
    var urlParams: [String: String]? {
        switch self {
        case .category:
            return nil
        case .subCategory(let categoryID):
            return ["categoryId": String(categoryID)]
        }
    }
}






struct RequestCategory: RequestProtocol {
    var path = "/Api/ParentCatgories"
    var requestType = RequestType.GET

}

struct RequestSubCategory: RequestProtocol {
    var path = "/Api/SubCategories"
    var requestType = RequestType.GET
    var categoryID: Int
    var urlParams: [String : String?]
    
    init(categoryID: Int) {
        self.categoryID  = categoryID
        self.urlParams = ["categoryId": String(categoryID)]
    }
}
