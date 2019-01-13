import Foundation

extension URL {
    
    public func appending(query: String) -> URL{
        let urlString: String?
        
        if self.query != nil {
            urlString = "\(self.absoluteString)&\(query)"
        } else {
            urlString = "\(self.absoluteString)?\(query)"
        }
        
        if let urlString = urlString, let url = URL(string: urlString) {
            return url
        }
        
        return self
    }
}
