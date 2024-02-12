import Foundation

public class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
                case .success(let data, let response):
                do {
                    let feedItems = try FeedItemMapper.map(data, response)
                    completion(.success(feedItems))
                } catch {
                    completion(.failure(.invalidData))
                }
            case.failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
