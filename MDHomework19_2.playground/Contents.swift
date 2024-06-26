import Foundation
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

func makeRequest(host: String) -> URL? {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = host
    urlComponents.path = "/api/v2/facts/random"

    guard let url = urlComponents.url else {
        return nil
    }
    
    return url
}

getData(urlRequest: makeRequest(host: "uselessfacts.jsph.pl"), completion: {info in print(info)})
