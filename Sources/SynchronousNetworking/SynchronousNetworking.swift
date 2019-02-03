import Foundation

public struct SynchronousNetworking {
    let baseUrl: URL
    let session = URLSession.shared
    
    public init(baseUrl: URL) {
        self.baseUrl = baseUrl
    }
    
    /**
     Performs a synchronous GET request to a path relative to `baseUrl`.
     
     - Parameter path A path relative to `baseUrl`.
     - Parameter parameters A dictionary of parameters that will get URL-encoded.
     */
    public func getSynchronously(path: String, parameters: [String: Any]) -> NetworkResponse {
        let url = relativeUrlFor(path: path)
        let request = urlEncodedHttpRequest(url: url, parameters: parameters)
        
        return performSynchronousRequest(request: request)
    }
    
    /**
     Performs a synchronous GET request to a URL, ignoring `baseUrl`.
     
     - Parameter url URL to request.
     - Parameter parameters A dictionary of parameters that will get URL-encoded.
     */
    public func getSynchronously(url: URL, parameters: [String: Any]) -> NetworkResponse {
        let request = urlEncodedHttpRequest(url: url, parameters: parameters)
        return performSynchronousRequest(request: request)
    }
    
    /**
     Performs a synchronous POST request to a path relative to `baseUrl`.
     
     - Parameter path A path relative to `baseUrl`.
     - Parameter parameters A dictionary of parameters that will get JSON-encoded.
     */
    public func postSynchronously(path: String, parameters: [String: Any], headers: [String: String]? = nil) -> NetworkResponse {
        let url = relativeUrlFor(path: path)
        var request = jsonBodyHttpRequest(url: url, method: "POST", parameters: parameters)
        
        if let headers = headers {
            request = requestByAdding(headers: headers, forRequest: request)
        }
        
        return performSynchronousRequest(request: request)
    }
    
    /**
     Performs a synchronous PUT request to a path relative to `baseUrl`.
     
     - Parameter path A path relative to `baseUrl`.
     - Parameter parameters A dictionary of parameters that will get JSON-encoded.
     */
    public func putSynchronously(path: String, parameters: [String: Any]) -> NetworkResponse {
        let url = relativeUrlFor(path: path)
        let request = jsonBodyHttpRequest(url: url, method: "PUT", parameters: parameters)
        return performSynchronousRequest(request: request)
    }

    func requestByAdding(headers: [String: String], forRequest request: URLRequest) -> URLRequest {
        var requestWithHeader = request
        
        for (key, value) in headers {
            requestWithHeader.setValue(value, forHTTPHeaderField: key)
        }
        
        return requestWithHeader
    }
    
    func performSynchronousRequest(request: URLRequest) -> NetworkResponse {
        let semaphore = DispatchSemaphore(value: 0)
        var networkResponse = NetworkResponse(request: nil, response: nil, data: nil, error: nil)
        
        let task = session.dataTask(with: request) { (data, urlResponse, error) in
            networkResponse.request = request
            networkResponse.response = urlResponse as? HTTPURLResponse
            networkResponse.data = data
            networkResponse.error = error
            
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        
        return networkResponse
    }
    
    func jsonBodyHttpRequest(url: URL, method: String, parameters: [String: Any]) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        urlRequest.httpBody = jsonData
        urlRequest.httpMethod = method
        
        urlRequest = requestByAdding(headers: ["Content-Type": "application/json; charset=utf-8"],
                                     forRequest: urlRequest)
        return urlRequest
    }
    
    func relativeUrlFor(path: String) -> URL {
        let url = baseUrl.appendingPathComponent(path)
        return url
    }
    
    func urlEncodedHttpRequest(url: URL, parameters: [String: Any]) -> URLRequest {
        let query = queryStringFor(parameters: parameters)
        let encodedURL = url.appending(query: query)
        
        var urlRequest = URLRequest(url: encodedURL)
        urlRequest.httpMethod = "GET"
        
        return urlRequest
    }
    
    func queryStringFor(parameters: [String: Any]) -> String {
        var urlParameters = [String]()
        
        for (key, value) in parameters {
            guard let stringValue = value as? String else {
                continue
            }
            
            var characters = NSCharacterSet.urlQueryAllowed
            characters.remove(charactersIn: "&")
            
            if let encodedValue = stringValue.addingPercentEncoding(withAllowedCharacters: characters) {
                let parameters = "\(key)=\(encodedValue)"
                urlParameters.append(parameters)
            }
        }
        
        return urlParameters.joined(separator: "&")
    }

}
