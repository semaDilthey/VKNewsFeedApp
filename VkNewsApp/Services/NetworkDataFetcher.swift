
//  Created by Семен Гайдамакин on 15.06.2023.
//

import Foundation

// Для начала создадим интерфейс, который будет преобразовывать JSON в нужный нам формат
protocol DataFetcher {
    func getFeed(nextBatchFrom: String?, response: @escaping (FeedResponse?) -> Void)
    
    func getUser(response: @escaping (UserResponse?) -> Void)
}

struct NetworkDataFetcher: DataFetcher {
    
    let networking: Networking
    
    private let authService: AuthService
    
    init(networking: Networking, authService: AuthService = SceneDelegate.shared().authService) {
        self.networking = networking
        self.authService = authService
    }
    // для ленты новостей
    func getFeed(nextBatchFrom: String?, response: @escaping (FeedResponse?) -> Void) {
        
        var params = ["filters": "post, photo"]
        params["start_from"] = nextBatchFrom
        networking.request(path: API.newsFeed, params: params) { (data, error) in
            if let error = error {
                print("Error recieved requesting data : \(error.localizedDescription)")
                response(nil)
            }
            
            let decoded = self.decodeJSON(type: FeedResponseWrapped.self, from: data)
            response(decoded?.response)
        }
    }
    // для инфе о юзере
    func getUser(response: @escaping (UserResponse?) -> Void) {
        guard let userId = authService.userId else { return }
        let params = ["user_ids": userId, "fields": "photo_100"]
        
        networking.request(path: API.user, params: params) { (data, error) in
            if let error = error {
                print("Error recieved requesting data : \(error.localizedDescription)")
                response(nil)
            }
            let decoded = self.decodeJSON(type: UserResponseWrapped.self, from: data)
            response(decoded?.response.first)
        }
    }
    
    
    // протой декодер, юзать можн везде
    private func decodeJSON<T: Decodable>(type: T.Type, from data: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase // конвертирует с кейсов_с_таким_знаком
        guard let data = data, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    //response?.response.items.map({ (feedItem) in // таким образом можно вывести например отдельно только текст поста
    //                print(feedItem.text)
    }
    
}
