//
//  NetWorkAPI.swift
//  WorkersFreeTime
//
//  Created by 栗志 on 2018/12/2.
//  Copyright © 2018年 com.lizhi1026. All rights reserved.
//

import Foundation
import Moya

let netWorkProvider = MoyaProvider<NetWorkAPI>(requestClosure: requestTimeoutClosure, plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])

private let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<NetWorkAPI>.RequestResultClosure) in
    
    do {
        var request = try endpoint.urlRequest()
        request.timeoutInterval = 10    //设置请求超时时间
        done(.success(request))
    } catch let error  {
        print(error)
    }
}

func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data
    }
}

public enum NetWorkAPI{
    
}

extension NetWorkAPI: TargetType{
    public var baseURL: URL {
        return URL(string: "192.168.1.102:8080")!
    }
    
    public var path: String {
        return ""
    }
    
    public var method: Moya.Method {
        return .post
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        return .requestParameters(parameters: ["name" : "lisi"], encoding: JSONEncoding.default)
    }
    
    public var headers: [String : String]? {
        return ["Content-type": "application/x-www-form-urlencoded"]
    }
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}
