//
//  NetworkService.swift
//  spotify-practice
//
//  Created by HeonJin Ha on 9/23/23.
//

import Foundation
import Combine

final class NetworkService: RestProtocol {
    
    private var session = URLSession.shared
    var cancellables = Set<AnyCancellable>()
    
    func cancel() {
        cancellables = .init()
    }
    
    func GET<T>(headerType: HttpHeader,
                urlString baseUrl: String,
                endPoint: String,
                parameters: [String: String] = [:],
                returnType: T.Type) -> Future<T, Error> where T: Codable {
        return Future<T, Error> { [weak self] promise in
            guard let self = self else {
                return promise(.failure(NetworkError.selfIsNil))
            }
            
            let urlString = "\(baseUrl)\(endPoint)\(parameterQueryHandler(from: parameters))"
            print("DEBUG urlString: \(urlString)")
            guard let url = URL(string: urlString) else {
                return promise(.failure(NetworkError.invalidUrl))
            }
            
            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = headerType.get()
            request.httpMethod = HttpMethod.GET.rawValue

            tryDataTaskPublisher(request: request)
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(error))
                        }
                    }
                }, receiveValue: {
                    promise(.success($0))
                })
                .store(in: &self.cancellables)
        }
    }
    
    func POST<T>(headerType: HttpHeader,
                 urlString baseUrl: String,
                 endPoint: String,
                 body rawBody: [String: String] = [:],
                 returnType: T.Type) -> Future<T, Error> where T: Codable {
        return Future<T, Error> { [weak self] promise in
            
            guard let self = self else {
                return promise(.failure(NetworkError.selfIsNil))
            }
            
            let urlString = "\(baseUrl)\(endPoint)"
            print("DEBUG urlString: \(urlString)")
            guard let url = URL(string: urlString) else {
                return promise(.failure(NetworkError.invalidUrl))
            }
            
            let queryItems: [URLQueryItem] = rawBody
                .map { item in
                return URLQueryItem(name: item.key, value: item.value)
            }
            
            var bodyComponent = URLComponents()
            bodyComponent.queryItems = queryItems
            let httpBody = bodyComponent.query?.data(using: .utf8)

            var request = URLRequest(url: url)
            request.allHTTPHeaderFields = headerType.get()
            request.httpMethod = HttpMethod.POST.rawValue
            request.httpBody = httpBody
                        
            tryDataTaskPublisher(request: request)
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(error))
                        }
                    }
                }, receiveValue: {
                    promise(.success($0))
                })
                .store(in: &self.cancellables)
        }
    }
    
}

extension NetworkService {
    private func parameterQueryHandler(from parameters: [String: String]) -> String {
        var queryString = ""
        
        if !parameters.isEmpty {
            queryString += "?"
            for parameter in parameters {
                queryString += "\(parameter.key)=\(parameter.value)&"
            }
        }
        
        if queryString.last == "&" {
            queryString.removeLast()
        }
        
        return queryString
    }
    
    // MARK: - Try DataTask Publisher
    private func tryDataTaskPublisher(request: URLRequest) -> Publishers.TryMap<URLSession.DataTaskPublisher, Data> {
        return self.session.dataTaskPublisher(for: request)
            .tryMap { (data, response) -> Data in
                print("DEBUG data: \(String(decoding: data, as: UTF8.self))")
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.responseError
                }
                guard 200...299 ~= httpResponse.statusCode else {
                    throw NetworkError.statusCode(httpResponse.statusCode)
                }
                return data
            }
    }
    
}
