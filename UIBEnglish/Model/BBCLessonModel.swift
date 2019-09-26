//
//  BBCLessonModel.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 2/19/19.
//  Copyright © 2019 UIB. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let bBCLessonModel = try? newJSONDecoder().decode(BBCLessonModel.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseBBCLessonModel { response in
//     if let bBCLessonModel = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

struct BBCLessonModel: Codable {
    let audioURL: String?
    let vocabulary: [Transcript]?
    let transcript: [Transcript]?
    let status: Int?
    
    enum CodingKeys: String, CodingKey {
        case audioURL = "audio_url"
        case vocabulary, transcript, status
    }
}

struct Transcript: Codable {
    let id, word, sentence, definition: String?
}

struct Vocabulary: Codable {
    let id, word, definition: String?
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
    func responseBBCLessonModel(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<BBCLessonModel>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}

