//  HTTPBody.swift
//  OpenMarket
//  Created by SummerCat on 2022/12/12.

import Foundation

enum ContentType: String {
    case json = "application/json"
    case imageJPEG = "image/jpeg"
    case imageJPG = "image/jpg"
    case imagePNG = "image/png"
}

struct HTTPBody {
    var contentType: ContentType
    var key: String {
        switch contentType {
        case .json:
            return "params"
        case .imageJPEG, .imageJPG, .imagePNG:
            return "images"
        }
    }
    var data: Data
    
    let linebreak: String = "\r\n"
    
    func createBody(boundary: String) -> Data {
        var body = Data()
        body.appendString("\(boundary)\(linebreak)")
        body.appendString("Content-Disposition: form-data; name = \"\(key)\"\(linebreak)")

        if contentType != .json {
            body.appendString("; filename=\"\(data.description)\"")
            body.appendString("Content-Type: \(contentType.rawValue)\(linebreak)")
        }
        body.appendString(linebreak)
        body.append(data)
        
        return body
    }
}

extension Data {
    mutating func appendString(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        self.append(data)
    }
}
