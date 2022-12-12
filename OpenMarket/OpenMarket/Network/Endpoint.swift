//  OpenMarketApi.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/18.

import Foundation

enum Endpoint {
    case healthChecker
    case fetchProductList(pageNumber: Int = 1, itemsPerPage: Int = 20)
    case fetchProductDetail(id: Product.ID)
    case registerProduct(requestID: UUID, requestBody: [HTTPBody])
}

extension Endpoint {
    var httpMethod: HTTPMethod {
        switch self {
        case .healthChecker, .fetchProductList, .fetchProductDetail:
            return .get
        case .registerProduct:
            return .post
        }
    }
    
    var baseURL: String {
        return "https://openmarket.yagom-academy.kr"
    }
    
    var path: String {
        switch self {
        case .healthChecker:
            return "/healthChecker"
        case .fetchProductList(_, _):
            return "/api/products"
        case .fetchProductDetail(id: let id):
            return "/api/products/\(id)"
        case .registerProduct:
            return "/api/products"
        }
    }
    
    var queries: [URLQueryItem] {
        switch self {
        case .fetchProductList(pageNumber: let pageNumber, itemsPerPage: let itemsPerPage):
            var queryParameters: [URLQueryItem] = []
            queryParameters.append(URLQueryItem(name: "page_no", value: "\(pageNumber)"))
            queryParameters.append(URLQueryItem(name: "items_per_page", value: "\(itemsPerPage)"))
            return queryParameters
        default:
            return []
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .registerProduct(let id, _):
            return [
                "identifier": "cf9b378a-6941-11ed-a917-a3e83c9cac31",
                "Content-Type": "multipart/form-data; boundary=\(id.uuidString)"
            ]
        default:
            return [:]
        }
    }
    
    var httpBody: Data {
        switch self {
        case .registerProduct(let id, let requestBody):
            let boundary: String = "--\(id.uuidString)"
            var body = Data()
            requestBody.forEach {
                body.append($0.createBody(boundary: boundary))
            }
            body.appendString("\(boundary)--")
            return body
        default:
            return Data()
        }
    }
    
    func createURLRequest() -> URLRequest? {
        guard var components = URLComponents(string: self.baseURL) else { return nil }
        components.path = path
        components.queryItems = self.queries
        
        guard let url = components.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        headers.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        request.httpBody = httpBody

        return request
    }
}
