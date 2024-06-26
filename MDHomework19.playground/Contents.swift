import Foundation
import CryptoKit

func getData(urlRequest: URL?, completion: @escaping ((String) -> Void)) {
    
    guard let url = urlRequest else { return }

    URLSession.shared.dataTask(with: url) { data, response, error in
        if error != nil {
            completion("code:\((response as? HTTPURLResponse)?.statusCode), \(error)")
        } else if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            guard let data = data else { return }
            let dataAsString = String(data: data, encoding: .utf8)
            completion(dataAsString!)
        }
        else {
            completion("code:\((response as? HTTPURLResponse)?.statusCode)")
        }
    }.resume()
}

func MD5(string: String) -> String {
    let digest = Insecure.MD5.hash(data: Data(string.utf8))

    return digest.map {
        String(format: "%02hhx", $0)
    }.joined()
}

func makeRequest(host: String) -> URL? {
    var pk = "9d9bdabab8b1d7670eadccbc97945fb3aaa8ba86"
    var ts = "1"
    var apikey = "f85865d962e7db44477b478f45ac83ed"
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = host
    urlComponents.path = "/v1/public/comics"
    urlComponents.queryItems = [URLQueryItem(name: "ts", value: ts),
                                URLQueryItem(name: "apikey", value: apikey),
                                URLQueryItem(name: "hash", value: MD5(string: ts+pk+apikey))]
    guard let url = urlComponents.url else {
        return nil
    }
    
    return url
}



getData(urlRequest: makeRequest(host: "gateway.marvel.com"), completion: {info in print(info)})
