//
//  JSONParameterEncoder.swift
//  WeatherTest
//
//  Created by Trexoz MCL on 14.03.2020.
//  Copyright © 2020 nktskr. All rights reserved.
//

import Foundation

public struct JSONParameterEncoder: ParameterEncoder {
    public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            print(String(data: jsonAsData, encoding: .utf8)!)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch (let err) {
            print("encodingFailed:", err)
            throw NetworkError.encodingFailed
        }
    }
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        do {
            let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return dictionary as! [String: Any]
        } catch (let err) {
            throw err
        }
    }
}

extension Array where Element: Encodable {
    func asDictionary() throws -> [[String: Any]] {
        var items = [[String: Any]]()
        do {
            for item in self {
                items.append(try item.asDictionary())
            }
            return items
        } catch (let err) {
            throw err
        }
    }
}

