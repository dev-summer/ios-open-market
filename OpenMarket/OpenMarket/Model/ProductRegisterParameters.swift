//  ProductRegisterParameters.swift
//  OpenMarket
//  Created by SummerCat on 2022/12/12.

import Foundation

struct ProductRegisterParameters: Encodable {
    let name: String
    let productDescription: String
    let currency: Currency
    let price: Double
    let discountedPrice: Double
    let stock: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case productDescription = "description"
        case currency
        case price
        case discountedPrice = "discounted_price"
        case stock
    }
}
