//  MultipartFormData.swift
//  OpenMarket
//  Created by SummerCat on 2022/12/12.

import Foundation

struct MultipartFormData {
    let linebreak: String = "\r\n"
    lazy var HTTPHeader: String = "Content-Type: multipart/form-data; boundary=\(boundary)"
    var boundary: String = UUID().uuidString
    
    private func createBoundary() -> String {
        return "\(UUID().uuidString)"
    }
    
    // body의 종류는 총 2가지
    // Content-Disposition: form-data; name = "params"
    // json객체 1개 포함
    // name = "images"
    // 이미지 1~5장 포함
    private func convertData(parameterName name: String, value: String, boundary: String) -> String {
        var body: String = "--\(boundary)\(linebreak)"
        body += "Content-Disposition: form-data; name = \"\(name)\"\(linebreak)"
        body += linebreak
        body += "\(value)\(linebreak)"
        
        return body
    }
    
    private func convertFileData(parameterName name: String, fileName: String, mimeType: String, fileData: Data, boundary: String) -> Data {
        var data = Data()
        data.appendString("--\(boundary)\(linebreak)")
        data.appendString("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\(linebreak)")
        data.appendString("Content-Type: \(mimeType)\(linebreak)")
        data.appendString(linebreak)
        data.append(fileData)
        
        return data
    }
}

extension Data {
    mutating func appendString(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        self.append(data)
    }
}
