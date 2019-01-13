import XCTest
@testable import SynchronousNetworking

final class SynchronousNetworkingTests: XCTestCase {

    func testQueryStringCreation() {
        let parameters = [
            "param1": "value1"
        ]
        
        let networking = SynchronousNetworking(baseUrl: URL(string: "http://example.com")!)
        
        let queryString = networking.queryStringFor(parameters: parameters)
        
        XCTAssert(queryString == "param1=value1", "Failed to encode query string.")
    }
    
    func testQueryStringCreationWithSpecialCharacters() {
        let parameters = [
            "param1": "value 1& value 2"
        ]
        
        let networking = SynchronousNetworking(baseUrl: URL(string: "http://example.com")!)
        
        let queryString = networking.queryStringFor(parameters: parameters)
        
        XCTAssert(queryString == "param1=value%201%26%20value%202", "Failed to encode query string.")
    }
    
    func testQueryStringCreationWithPlusSign() {
        let parameters = [
            "param1": "1+2"
        ]
        
        let networking = SynchronousNetworking(baseUrl: URL(string: "http://example.com")!)
        
        let queryString = networking.queryStringFor(parameters: parameters)
        
        XCTAssert(queryString == "param1=1+2", "Failed to encode query string.")
    }
    
    func testAddingHeaders() {
        let headers = ["header": "value"]
        let url = URL(string: "http://example.com")!
        var urlRequest = URLRequest(url: url)
        
        let networking = SynchronousNetworking(baseUrl: url)
        urlRequest = networking.requestByAdding(headers: headers, forRequest: urlRequest)
        
        XCTAssert(urlRequest.allHTTPHeaderFields == headers)
    }
    
    func testPostRequestHasCorrectHeaders() {
        let url = URL(string: "http://example.com")!
        let networking = SynchronousNetworking(baseUrl: url)
        let headers = ["header": "value"]
        let request = networking.jsonBodyHttpRequest(url: url, method: "POST", parameters: headers)
        let expectedHeader = ["Content-Type": "application/json; charset=utf-8"]
        
        XCTAssert(request.allHTTPHeaderFields == expectedHeader)
    }
    
}

#if os(Linux)
extension SynchronousNetworkingTests {
    static var allTests : [(String, SynchronousNetworkingTests -> () throws -> Void)] {
        return [
            ("testQueryStringCreation", testQueryStringCreation),
            ("testQueryStringCreationWithSpecialCharacters", testQueryStringCreationWithSpecialCharacters),
            ("testQueryStringCreationWithPlusSign", testQueryStringCreationWithPlusSign),
            ("testAddingHeaders", testAddingHeaders),
            ("testPostRequestHasCorrectHeaders", testPostRequestHasCorrectHeaders)
        ]
    }
}
#endif
