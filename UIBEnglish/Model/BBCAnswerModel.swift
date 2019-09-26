// To parse the JSON, add this file to your project and do:
//
//   let bBCAnswerModel = try? newJSONDecoder().decode(BBCAnswerModel.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseBBCAnswerModel { response in
//     if let bBCAnswerModel = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

struct BBCAnswerModel: Codable {
    let success: Int?
    let results: [ResultBBC]?
    let overall: Int?
}

struct ResultBBC: Codable {
    let id, correct: Int?
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
    func responseBBCAnswerModel(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<BBCAnswerModel>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
