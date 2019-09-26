// To parse the JSON, add this file to your project and do:
//
//   let resultModel = try? newJSONDecoder().decode(ResultModel.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseResultModel { response in
//     if let resultModel = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

struct ResultModel: Codable {
    let success: Int?
    let message: String?
    let topics: [TopicResult]?
}

struct TopicResult: Codable {
    let title: String?
    let exercises: [Exercise]?
}

struct Exercise: Codable {
    let id, description: String?
    let results: [ResultEq]?
}

struct ResultEq: Codable {
    let overall, date: String?
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
    func responseResultModel(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<ResultModel>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
