
//  Created by Семен Гайдамакин on 15.06.2023.
//

import Foundation

// Для начала создадим интерфейс, который будет преобразовывать JSON в нужный нам формат
protocol DataFetcher {
    func getFeed(response: @escaping (FeedResponse?) -> Void)
}

struct NetworkDataFetcher: DataFetcher {
    let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    func getFeed(response: @escaping (FeedResponse?) -> Void) {
        let params = ["filters": "post, photo"]
        networking.request(path: API.newsFeed, params: params) { (data, error) in
            if let error = error {
                print("Error recieved requesting data : \(error.localizedDescription)")
                response(nil)
            }
            
            let decoded = self.decodeJSON(type: FeedResponseWrapped.self, from: data)
            response(decoded?.response)
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from data: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase // конвертирует с кейсов_с_таким_знаком
        guard let data = data, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    //response?.response.items.map({ (feedItem) in // таким образом можно вывести например отдельно только текст поста
    //                print(feedItem.text)
    }
    
}
