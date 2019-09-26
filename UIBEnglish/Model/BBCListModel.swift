//
//  BBCListModel.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 2/19/19.
//  Copyright © 2019 UIB. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let bBCListModel = try? newJSONDecoder().decode(BBCListModel.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseBBCListModel { response in
//     if let bBCListModel = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

struct BBCListModel: Codable {
    let lessons: [Lesson]?
    let status: Int?
}

struct Lesson: Codable {
    let id, title, description: String?
    let img: String?
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
    func responseBBCListModel(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<BBCListModel>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
