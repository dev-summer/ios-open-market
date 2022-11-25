//  ProductList.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/15.

import Foundation

struct Product: Decodable, Identifiable, Hashable {
    let id: Int
    let vendorID: Int
    let vendorName: String?
    let name: String
    let productDescription: String
    let thumbnailURL: String
    let currency: Currency
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdAt: String
    let issuedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case vendorID = "vendor_id"
        case vendorName
        case name
        case productDescription = "description"
        case thumbnailURL = "thumbnail"
        case currency
        case price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}
