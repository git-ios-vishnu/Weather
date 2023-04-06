//
//  WMNetwork.swift
//  WeatherModel
//
//  Created by Vishnu Ankinapalli on 4/3/23.
//

import Foundation

extension Notification.Name {
    static let didBeginNetworkCall = Notification.Name("didBeginNetworkCall")
    static let didEndNetworkCall = Notification.Name("didEndNetworkCall")
}

// This is a wrapper class for URLSession to handle customizations as per our needs
public class WeatherURLSession: ObservableObject {
    
    private var urlSession: URLSession
    
    @Published public private(set) var inProgressAPICalls = 0
    
    private struct WMNetworkConstants {
        static let maxConcurrentConnections = 10
        static let successHttpResponseCode = 200
    }
    
   public init(timeOut: Double) {
        let urlConfiguration = URLSessionConfiguration.ephemeral
        urlConfiguration.httpMaximumConnectionsPerHost = WMNetworkConstants.maxConcurrentConnections
        urlConfiguration.timeoutIntervalForRequest = timeOut
        
       urlSession = URLSession(configuration: urlConfiguration)
    }
    
    // Makes an API call to given URLRequest
    // Retries is not implemented for now but for future
    @discardableResult
    public func taskWithRequest(urlRequest: URLRequest, serviceName:String?, retries: Int, completionHandler: @escaping (_ data: Data?, _ error: Error?) -> ()) -> URLSessionDataTask {
        
        inProgressAPICalls += 1
        let uniqueID = UUID()
        // Making sure we post notification in main thread
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .didBeginNetworkCall, object: self)
        }
        
        // Printing log for debugging
        print("APICall:\(String(describing: serviceName)) uniqueID:\(uniqueID) \(urlRequest)")
        
        let dataTask = urlSession.dataTask(with: urlRequest) {[weak self] data, response, error in
            DispatchQueue.main.async {

                self?.inProgressAPICalls -= 1
                NotificationCenter.default.post(name: .didEndNetworkCall, object: self)
                
                if let data = data {
                    
                    let json = try? JSONSerialization.jsonObject(with: data)
                    print("APICall:\(String(describing: serviceName)) uniqueID:\(uniqueID) value:\(String(describing: json))")
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completionHandler(nil, WeatherError.httpError)
                        return
                    }
                    
                    if httpResponse.statusCode == WMNetworkConstants.successHttpResponseCode {
                        completionHandler(data, nil)
                    }
                    else {
                        completionHandler(data, WeatherError.failedWithHTTPStatusCode(statusCode: httpResponse.statusCode))
                    }
                    
                }
                else if let error = error {
                    completionHandler(nil, error)
                }
            }
        }
        
        dataTask.resume()
        
        return dataTask
    }
    
}
