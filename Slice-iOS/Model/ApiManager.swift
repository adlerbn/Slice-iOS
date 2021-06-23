//
//  API.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/21/21.
//

import Foundation

enum ApiType: String {
    case login = "/account/login"
    case register = "/account/register"
    case validation = "/account/validation"
}

enum HttpMethod: String {
    case GET
    case POST
}

class ApiManager {
    let type: ApiType
    let httpMethod: HttpMethod
//    let apiKey: String
    let baseUrl: String = "https://jakode-slice-api.herokuapp.com"
//    var jsonObject: [String:Any]
    var body: String?
    var header: [String: Any]?
    
    //Specify Header
//    let headers = [
//
//    ]
    
    init(type: ApiType, httpMethod: HttpMethod) {
        print("initialize API")
        self.type = type
        self.httpMethod = httpMethod
//        self.apiKey = ""
    }
    
    func fetchURL() {
        print("fetchURL")
        let urlString: String = "\(baseUrl)\(type.rawValue)"
        print(urlString)
        performRequest(urlString)
    }
    
    func performRequest(_ urlString: String) {
        print("performRequest")
        //URL
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
//            request.allHTTPHeaderFields
            request.httpMethod = httpMethod.rawValue
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            let requestBody = body?.data(using: .utf8)
            request.httpBody = requestBody
            
            //Get The URL Session
            let session = URLSession.shared
            
            //Create The Data Task
            let dataTask = session.dataTask(with: request, completionHandler: handle(data: response: error: ))
            
            //Fire Of The Data Task
            dataTask.resume()
        }
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?) {
        print("handle")
        if error != nil {
            print("Fetch data, \(error!)")
            return
        }
        
        if let safeData = data {
            
            let dataString = String(data: safeData, encoding: .utf8)
            
            print("data: ",dataString!)
            checkResponse(dataString)
            
            //            do {
            //                let dictionary = try JSONSerialization.jsonObject(with: safeData, options: .mutableContainers) as! [String:Any]
            //
            //                print(dictionary)
            //            } catch {
            //                print("Error passing response data")
            //            }
        }
    }
    
    func register(_ name: String, _ email: String, _ validationCode: String) {
        body = "email=\(email)&nickname=\(name)&verificationCode=\(validationCode)"
        fetchURL()
    }
    
    func login(_ email: String, _ validationCode: String) {
        body = "email=\(email)&verificationCode=\(validationCode)"
        fetchURL()
    }
    
    func validationCode(_ email: String) {
        body = "email=\(email)"
        fetchURL()
    }
    
    func checkResponse(_ data: String?) {
        switch type {
        case .validation:
            print("checked Response Validation")
        case .login:
            print("checked Response Login")
        case .register:
            print("checked Response Register")
        }
    }
}
