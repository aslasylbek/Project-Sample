// To parse the JSON, add this file to your project and do:
//
//   let readingModel = try? newJSONDecoder().decode(ReadingModel.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseReadingModel { response in
//     if let readingModel = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire


struct ReadingModel: Codable {
    let id, reading: String?
    let questionanswer: [Questionanswer]?
    let truefalse: [Truefalse]?
}

struct Questionanswer: Codable {
    let id, question, answer: String?
}

struct Truefalse: Codable {
    let id, question, truefalse: String?
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
    func responseReadingModel(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<[ReadingModel]>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
