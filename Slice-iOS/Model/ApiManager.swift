//
//  API.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/21/21.
//

import Foundation

protocol ApiManagerDelegateStarter {
    func didUpdateDefaultSettings(with activity: ActivityData)
}

protocol ApiManagerDelegateHome {
    func didUpdateFoodItems(with food: FoodsData, apiType: ApiType)
}

protocol ApiManagerDelegateDetails {
    func didUpdateFoodDetails (with food: AdvanceFood, apiType: ApiType)
}

enum ApiType: String {
    case login = "/account/login"
    case register = "/account/register"
    case validation = "/account/validation"
    case specialOffer = "/foods/special-offer"
    case highestScores = "/foods/highest-scores"
    case bestSelling = "/foods/best-selling"
    case wishlist = "/wishlist"
    case foodsList = "/foods"
    case food = "/foods/"
}

enum HttpMethod: String {
    case GET
    case POST
    case DELETE
}

class ApiManager {
    private let type: ApiType
    private let httpMethod: HttpMethod
    private var token: String? = {
        let userDefaults = UserDefaults.standard
        let token = userDefaults.value(forKey: "token")
        return token as? String
    }()
    private let baseUrl: String = "https://jakode-slice-api.herokuapp.com"
    private var body: String?
    private var header: [String: Any]?
    
    var delegateStarter: ApiManagerDelegateStarter?
    var delegateHome: ApiManagerDelegateHome?
    var delegateDetails: ApiManagerDelegateDetails?
    
    init(type: ApiType, httpMethod: HttpMethod) {
        print("initialize API")
        self.type = type
        self.httpMethod = httpMethod
    }
    
    private func fetchURL(_ addOne: String = "") {
        print("fetchURL")
        let urlString: String = "\(baseUrl)\(type.rawValue)\(addOne)"
        print(urlString)
        performRequest(urlString)
    }
    
    private func performRequest(_ urlString: String) {
        print("performRequest")
        //URL
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20.0)
            request.httpMethod = httpMethod.rawValue
            
            if type == .login || type == .register || type == .validation {
                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                let requestBody = body?.data(using: .utf8)
                request.httpBody = requestBody
            } else {
                if let token = token {
                    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    print("Authorization is added to Header")
                }
            }
            //Get The URL Session
            let session = URLSession.shared
            
            //Create The Data Task
            let dataTask = session.dataTask(with: request, completionHandler: handle(data: response: error: ))
            
            //Fire Of The Data Task
            dataTask.resume()
        }
    }
    
    private func handle(data: Data?, response: URLResponse?, error: Error?) {
        print("handle")
        if error != nil {
            print("Fetch data, \(error!)")
            return
        }
        
        if let safeData = data {
//            print(String(data: safeData, encoding: .utf8))
            checkResponse(safeData)
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
    
    func getFoodsList(limit: Int,
                     page: Int,
                     search: String = "",
                     category: Category = .none,
                     isActive: IsActive = .none,
                     size: Size = .none,
                     price: String = "",
                     score: String = "",
                     time: String = "") {
        var addOne = "?limit=\(limit)&page=\(page)"
        
        if search != "" {
            addOne += "&search=\(search)"
        }
        if category != .none {
            addOne += "&category=\(category.rawValue)"
        }
        if isActive != .none {
            addOne += "&isActive=\(isActive.rawValue)"
        }
        if size != .none {
            addOne += "&size=\(size.rawValue)"
        }
        if price != "" {
            addOne += "&price=\(price)"
        }
        if score != "" {
            addOne += "&score=\(score)"
        }
        if time != "" {
            addOne += "&time=\(time)"
        }
        
        fetchURL(addOne)
    }
    
    func getFood(foodId: Int) {
        let addOne = "\(foodId)"
        fetchURL(addOne)
    }
    
    private func checkResponse(_ data: Data) {
        switch type {
        case .validation:
            print("checked Response Validation")
        case .login:
            print("checked Response Login")
            if let activity = parseJSONActivityData(apiData: data) {
                delegateStarter?.didUpdateDefaultSettings(with: activity)
            }
        case .register:
            print("checked Response Register")
            if let activity = parseJSONActivityData(apiData: data) {
                delegateStarter?.didUpdateDefaultSettings(with: activity)
            }
        case .specialOffer:
            print("checked Response specialOffer")
            if let foodData = parseJSONFoodsData(apiData: data) {
                delegateHome?.didUpdateFoodItems(with: foodData, apiType: .specialOffer)
            }
        case .bestSelling:
            print("checked Response bestSelling")
            if let foodData = parseJSONFoodsData(apiData: data) {
                delegateHome?.didUpdateFoodItems(with: foodData, apiType: .bestSelling)
            }
        case .highestScores:
            print("checked Response highestScores")
            if let foodData = parseJSONFoodsData(apiData: data) {
                delegateHome?.didUpdateFoodItems(with: foodData, apiType: .highestScores)
            }
        case .wishlist:
            print("checked Response wishlist")
            if let foodData = parseJSONFoodsData(apiData: data) {
                delegateHome?.didUpdateFoodItems(with: foodData, apiType: .wishlist)
            }
        case .foodsList:
            print("checked Response foodList")
            if let foodData = parseJSONFoodsData(apiData: data) {
                delegateHome?.didUpdateFoodItems(with: foodData, apiType: .foodsList)
            }
        case .food:
            print("checked Response Food")
            if let foodData = parseJSONFoodData(apiData: data) {
                delegateDetails?.didUpdateFoodDetails(with: foodData, apiType: .food)
            }
        }
    }
    
    private func parseJSONActivityData(apiData: Data) -> ActivityData? {
        let jsonDecoder = JSONDecoder()
        do {
            let decodedData = try jsonDecoder.decode(ActivityData.self, from: apiData)
            let activityData = ActivityData(token: decodedData.token, user: decodedData.user)
            print("Token:", decodedData.token)
            return activityData
        } catch {
            print("Error Decoding Data Activity")
            return nil
        }
    }
    
    private func parseJSONFoodsData(apiData: Data) -> FoodsData? {
        
        let jsonDecoder = JSONDecoder()
        do {
            let decodedData = try jsonDecoder.decode(FoodsData.self, from: apiData)
            let foodsData = FoodsData(page: decodedData.page, count: decodedData.count, foodItems: decodedData.foodItems)
            return foodsData
        } catch {
            print("Error Decoding Data Foods")
            return nil
        }
    }
    
    private func parseJSONFoodData(apiData: Data) -> AdvanceFood? {
        let jsonDecoder = JSONDecoder()
        do {
            let decodedData = try jsonDecoder.decode(AdvanceFood.self, from: apiData)
            return decodedData
        } catch {
            print("Error Decoding Data Foods")
            return nil
        }
    }
}
