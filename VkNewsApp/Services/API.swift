
//  Created by Семен Гайдамакин on 14.06.2023.
//

import Foundation

struct API {
    static let scheme = "https" // порт
    static let host = "api.vk.com" // постоянный адрес хоста
    static let version = "5.131" // версия постоянна
    static let newsFeed = "/method/newsfeed.get" // путь к новостям с документации ВК.  Возвращает данные, необходимые для показа списка новостей для текущего пользователя.
    
    static let user = "/method/users.get"
}
