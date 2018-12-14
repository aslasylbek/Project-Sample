// To parse the JSON, add this file to your project and do:
//
//   let listeningModel = try? newJSONDecoder().decode(ListeningModel.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseListeningModel { response in
//     if let listeningModel = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire


struct ListeningModel: Codable {
    let id, listening: String?
    let translate: JSONNull?
    let questionanswer: [Questionanswer]?
    let soundURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id, listening, translate, questionanswer
        case soundURL = "sound_url"
    }
}


// MARK: Encode/decode helpers


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
    func responseListeningModel(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<[ListeningModel]>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
