//
//  BBCCategoryModel.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 2/19/19.
//  Copyright © 2019 UIB. All rights reserved.
//
// To parse the JSON, add this file to your project and do:
//
//   let bBCCategoryModel = try? newJSONDecoder().decode(BBCCategoryModel.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseBBCCategoryModel { response in
//     if let bBCCategoryModel = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

struct BBCCategoryModel: Codable {
    let categories: [Category]?
    let status: Int?
}

struct Category: Codable {
    let id, title, level, description: String?
}

// MARK: - Alamofire response handlers

extension DataRequest {
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            guard error == nil else { return .failure(error!) }
            
            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            return Result { try newJSONDecoder().decode(T.self, from: data) }
        }
    }
    
    @discardableResult
    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseBBCCategoryModel(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<BBCCategoryModel>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}

