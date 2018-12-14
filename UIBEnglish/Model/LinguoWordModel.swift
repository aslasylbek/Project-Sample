// To parse the JSON, add this file to your project and do:
//
//   let linguoWordModel = try? newJSONDecoder().decode(LinguoWordModel.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseLinguoWordModel { response in
//     if let linguoWordModel = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

struct LinguoWordModel: Codable {
    let errorMsg, translateSource: String?
    let isUser: Int?
    let wordForms: [WordForm]?
    let picURL: String?
    let translate: [Translate]?
    let transcription: String?
    let wordID, wordTop: Int?
    let soundURL: String?
    
    enum CodingKeys: String, CodingKey {
        case errorMsg = "error_msg"
        case translateSource = "translate_source"
        case isUser = "is_user"
        case wordForms = "word_forms"
        case picURL = "pic_url"
        case translate, transcription
        case wordID = "word_id"
        case wordTop = "word_top"
        case soundURL = "sound_url"
    }
}

struct Translate: Codable {
    let id: Int?
    let value: String?
    let votes, isUser: Int?
    let picURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id, value, votes
        case isUser = "is_user"
        case picURL = "pic_url"
    }
}

struct WordForm: Codable {
    let word, type: String?
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
    func responseLinguoWordModel(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<LinguoWordModel>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
