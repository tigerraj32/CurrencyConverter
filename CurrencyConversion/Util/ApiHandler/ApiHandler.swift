//
//  ApiHandler.swift
//  CurrencyConversion
//
//  Created by javra on 4/11/19.
//  Copyright © 2019 javra. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum ExchangeRateType {
    case live
    case history
}

class ApiHandler: NSObject {
    
    class func asLiveRequest(_ method: HTTPMethod, source: String) -> URLRequest? {
        
        guard var baseURL = URLComponents(string: Constant.URL.live) else {return nil}
        baseURL.queryItems = [
            URLQueryItem(name: "access_key", value: EnviromentalVariable.access_token),
            URLQueryItem(name: "source", value: source)
        ]
        
        var request = URLRequest(url: baseURL.url!)
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = method.rawValue
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = TimeInterval(10 * 1000)
        
        return request
        
    }
    
    class func asHistoryRequest(_ method: HTTPMethod, source: String, date: String) -> URLRequest? {
        
        guard var baseURL = URLComponents(string: Constant.URL.history) else {return nil}
        baseURL.queryItems = [
            URLQueryItem(name: "access_key", value: EnviromentalVariable.access_token),
            URLQueryItem(name: "source", value: source),
            URLQueryItem(name: "history", value: date)
        ]
        
        var request = URLRequest(url: baseURL.url!)
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.httpMethod = method.rawValue
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = TimeInterval(10 * 1000)
        
        return request
        
    }
    
    
    class func call(request: URLRequest, _ onSuccess: @escaping (Any)-> Void, _ onError: @escaping (NSError)->Void){
        let sessionConfig = URLSessionConfiguration.default
        
        /* Create session, and optionally set a URLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        debugPrint("Request: \(request) \n")
        
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            debugPrint("Resonnse Status: \(statusCode)")
            
            if (error == nil) {
                
                //let string = String(bytes: data!, encoding: String.Encoding.utf8)
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                    print(json)
                    let success = json["success"] as! Bool
                    if success {
                        onSuccess(json)
                    }else{
                        let errorDict = json["error"] as! [String: Any]
                        let error: NSError = NSError(domain: Bundle.main.bundleIdentifier ?? "", code: errorDict["code"] as! Int,
                                                   userInfo: [NSLocalizedDescriptionKey :errorDict["info"] as! String ])
                        onError(error)
                       
                    }
                    
                    //let conversions = json["quotes"] as! [String: String ]
                    
                }catch let error {
                    onError(error as NSError)
                }
            }
            else {
                // Failure
                
                print("URL Session Task Failed: %@", error!.localizedDescription);
                let error = NSError(domain: Bundle.main.bundleIdentifier ?? "", code: 0, userInfo: [NSLocalizedDescriptionKey : error?.localizedDescription as Any])
                onError(error)
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
        
    }
    
    class func conversionFromCached(_ source: String ) -> [String: Double]?{
        guard let expiresOn = ApplicationPrefrence.read(key: Constant.String.expiresOn) as? TimeInterval else{return nil}
        if  expiresOn > Date().timeIntervalSince1970{
            //cached not expired
            guard let allConversions = ApplicationPrefrence.read(key: Constant.String.quotes) as? [String : Any] else { return nil }
            guard let conversions = (allConversions[source] as? [String: Double])  else{ return nil}
            return conversions
        }
        
        //cached  expired
        ApplicationPrefrence.remove(key: Constant.String.quotes)
        ApplicationPrefrence.remove(key: Constant.String.expiresOn)
        return nil
    }
    
    static func cachedConversion(for source: String, conversion rates:[String: Double]) {
        
        let expiresOn = Date().timeIntervalSince1970 + Constant.URL.cacheInterval
        var cachedRates:[String: [String: Double]] = ApplicationPrefrence.read(key: Constant.String.quotes) as? [String: [String: Double]]  ?? [:]
        cachedRates[source] = rates
        
        ApplicationPrefrence.save(key: Constant.String.expiresOn, object: expiresOn as AnyObject)
        ApplicationPrefrence.save(key: Constant.String.quotes, object: cachedRates as AnyObject)
        
    }
    
}
