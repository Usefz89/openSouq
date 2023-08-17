//
//  Category.swift
//  openSouq
//
//  Created by Yousef Zuriqi on 17/08/2023.
//

import Foundation


struct Category: Codable {
    let productCategoryId: Int
    let nameAr: String
    let nameEn: String
    let name: String
    let showInHomePage: Bool
    let seoName: String
    let picture: String
    let order: Int
    let parentId: Int?
    let parentNameAr: String
    let parentNameEn: String
    let parentName: String
    let rowNumber: Int
    let subcategories: String?
    let subProductCategoriesCount: Int
    let disabled: Bool
    let isLastChild: Bool
    
    private enum CodingKeys: String, CodingKey {
        case productCategoryId = "ProductCategoryId"
        case nameAr = "NameAr"
        case nameEn = "NameEn"
        case name = "Name"
        case showInHomePage = "ShowInHomePage"
        case seoName = "SeoName"
        case picture = "Picture"
        case order = "Order"
        case parentId = "ParentId"
        case parentNameAr = "ParentNameAr"
        case parentNameEn = "ParentNameEn"
        case parentName = "ParentName"
        case rowNumber = "RowNumber"
        case subcategories = "Subcategories"
        case subProductCategoriesCount = "SubProductCategoriesCount"
        case disabled = "Disabled"
        case isLastChild = "IsLastChild"
    }
}


