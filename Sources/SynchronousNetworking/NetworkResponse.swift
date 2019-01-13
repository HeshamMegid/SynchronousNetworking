import Foundation

public struct NetworkResponse {
    public var request: URLRequest?
    public var response: HTTPURLResponse?
    public var data: Data?
    public var error: Error?
}
