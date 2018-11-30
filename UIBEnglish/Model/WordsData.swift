//
//  WordsData.swift
//  UIBEnglish
//
//  Created by UIB_CIT on 11.10.2018.
//  Copyright © 2018 UIB. All rights reserved.
//

import Foundation


typealias WordsData = [WordsDatum]

struct WordsDatum: Codable {
    let id, word: String?
    let type: String?
    let picURL: String?
    let transcription: String?
    let soundURL: String?
    let translateWord, rating: String?
    var isExpanded: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, word, type
        case picURL = "pic_url"
        case transcription
        case soundURL = "sound_url"
        case translateWord = "translate_word"
        case rating
    }
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URLRequest, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
    
    func wordsDataTask(with url: URLRequest, completionHandler: @escaping (WordsData?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
