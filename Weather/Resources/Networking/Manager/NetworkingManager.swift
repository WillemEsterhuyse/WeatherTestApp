import Alamofire
import PromiseKit

protocol Networking: class {
    func responseDecodable<T: Decodable>(route: Route, decoder: JSONDecoder) -> Promise<T>
}

extension Networking {
    func responseDecodable<T: Decodable>(route: Route) -> Promise<T> {
        return responseDecodable(route: route, decoder: JSONDecoder())
    }
}

final class NetworkingManager: Networking {
    func responseDecodable<T>(route: Route, decoder: JSONDecoder) -> Promise<T> where T: Decodable {
        return performResponseDecodable(route: route, decoder: decoder)
    }

    @discardableResult
    private func performResponseDecodable<T: Decodable>(route: Route, decoder: JSONDecoder = JSONDecoder()) -> Promise<T> {

        let result = Promise<T> { seal in

            AF.request(route).validate().responseDecodable(of: T.self,
                                                           decoder: decoder,
                                                           completionHandler: { (response) in
                
                switch response.result {
                case .success(let success):
                    seal.fulfill(success)
                case .failure(let error):
                    seal.reject(error)
                }
            })
        }

        return result
    }
    
}
