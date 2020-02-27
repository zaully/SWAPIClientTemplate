//
//  HttpService.swift
//  StarWarsCharacters
//
//  Created by Vince Liang on 2020-02-24.
//  Copyright © 2020 Vince. All rights reserved.
//

import Foundation

protocol ApiEndpoint {
    var url: URL { get }
}

protocol HttpSession: class {
    func request(for url: URL, completion: @escaping ([String: Any]?, URLResponse?, Error?) -> Void)
}

protocol HttpService: class {
    func requestJson(for url: URL, completion: ((HttpRequestResult) -> Void)?)
    func requestJson(for endpoint: ApiEndpoint, completion: ((HttpRequestResult) -> Void)?)
}

enum HttpRequestResult {
    case success(code: Int, json: [String: Any])
    case failure(error: AppError)
}

class HttpServiceImpl: HttpService {

    private let session: HttpSession

    init(session: HttpSession = URLSession.shared) {
        self.session = session
    }

    func requestJson(for endpoint: ApiEndpoint, completion: ((HttpRequestResult) -> Void)?) {
        requestJson(for: endpoint.url, completion: completion)
    }

    func requestJson(for url: URL, completion: ((HttpRequestResult) -> Void)?) {
        session.request(for: url) { (json: [String: Any]?, response: URLResponse?, error: Error?) in
            if let error = error {
                completion?(.failure(error: error as NSError))
                return
            }
            guard let res = response as? HTTPURLResponse else {
                completion?(.failure(error: NSError(code: -1, description: "Invalid Response".localized)))
                return
            }
            if !(200...299).contains(res.statusCode) {
                let desc = HTTPURLResponse.localizedString(forStatusCode: res.statusCode)
                completion?(.failure(error: NSError(code: res.statusCode, description: desc)))
                return
            }
            completion?(.success(code: res.statusCode, json: json ?? [:]))
        }
    }
}

extension URLSession: HttpSession {
    func request(for url: URL, completion: @escaping ([String: Any]?, URLResponse?, Error?) -> Void) {
        let task = dataTask(with: url) { (data, res, err) in
            var json: [String: Any]?
            if let data = data {
                json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            }
            DispatchQueue.main.async {
                completion(json, res, err)
            }
        }
        task.resume()
    }
}
