
// To parse the JSON, add this file to your project and do:
//
//   let grammarModel = try? newJSONDecoder().decode(GrammarModel.self, from: jsonData)
//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseGrammarModel { response in
//     if let grammarModel = response.result.value {
//       ...
//     }
//   }
import Foundation
import Alamofire


struct GrammarModel: Codable {
    let missword: [Missword]?
    let constructor: [Constructor]?
}

struct Constructor: Codable {
    let id, sentence, translate: String?
}

struct Missword: Codable {
    let id, sentence, question, answer: String?
    let translate: String?
    let soundURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id, sentence, question, answer, translate
        case soundURL = "sound_url"
    }
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
    func responseGrammarModel(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<[GrammarModel]>) -> Void) -> Self {
        return responseDecodable(queue: queue, completionHandler: completionHandler)
    }
}
