
//  Created by Семен Гайдамакин on 14.06.2023.
//

import Foundation

protocol Networking {
    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void)
}

final class NetworkService: Networking {
   
    private let authService: AuthService
    
    init(authService: AuthService = SceneDelegate.shared().authService) {
        self.authService = authService
    }
    
    // 3. Функция конечного запроса
    func request(path: String, params: [String : String], completion: @escaping (Data?, Error?) -> Void) {
        guard let token = authService.token else { return } // получает токен вк, что-то тоже из доки
        
        
        var allParams = params
        allParams["access_token"] = token // добавляет новое значение в словарь
        allParams["v"] = API.version // и еще одно новое значение
        
        let url = self.url(from: path, params: allParams)
        
        let request = URLRequest(url: url)
        let task = createDakaTask(from: request, completion: completion)
        print(url)
        task.resume()
        
    }
    
    
    // 2. Функция для создания ДатаТаска
    private func createDakaTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error) // когда приходит дата или ошибка, мы записываем их в completion блок функции
            }
        }
    }
    
    // 1. func для получения URL
    private func url(from path: String, params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = path
        components.queryItems = params.map{ URLQueryItem(name: $0, value: $1) } // собирает последовательность в адрес, состояющую сначала из пост&фото, потом идет токен и затем версия
        
        return components.url! // собираетсся из предыдущих частей воедино
    }
}
