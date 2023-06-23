
//  Created by Семен Гайдамакин on 15.06.2023.
//

import Foundation


struct FeedResponseWrapped: Decodable {
    let response: FeedResponse
}

struct FeedResponse: Decodable {
    var items: [FeedItem]
    var profiles: [Profile]
    var groups: [Groups]
    
    var nextFrom : String?
}

struct FeedItem: Decodable {
    let sourceId: Int
    let postId: Int
    let text: String?
    let date: Double
    
    let comments: CountableItem?
    let likes: CountableItem?
    let reposts: CountableItem?
    let views: CountableItem?
    
    let attachments: [Attachment]?
}
// Получилась матрешка. Есть поле attachments выше. У поля attachments в struct Attachment есть поле Photo, у Photot есть размеры sizes. В структе Photo выбирали нужный размер из всех в функции getProperSize и только потом уже заполняли свойства height, width etc
struct Attachment : Decodable {
    let photo: Photo?
}

struct Photo: Decodable {
    let sizes: [PhotoSize]
    
    var height: Int {
        return getPropperSize().height
    }
    
    var width: Int {
        return getPropperSize().width
    }
    // url для фото
    var srcBIG: String {
        return getPropperSize().url
    }
    // это необходимл только для этого варианта, ибо нам приходит много разных размеров
    private func getPropperSize() -> PhotoSize {
        // пробегаемся по массиву sizes пока не найдем размер типа Х
        
        if let sizeX = sizes.first(where: {$0.type == "x"}) {
            return sizeX
        } else if let fallBackSize = sizes.last {
            return fallBackSize
        } else {
            return PhotoSize(type: "wrong image", url: "wrong image", width: 0, height: 0)
        }
    }
}

struct PhotoSize: Decodable {
    let type: String
    let url: String
    let width: Int
    let height: Int
}

struct CountableItem: Decodable {
    let count: Int
}

// создаем протокол, ибо в Profile и group есть пересекающиеся переменные
protocol ProfileRepresentable {
    var id: Int { get }
    var name: String { get }
    var photo: String { get }
 }
struct Profile: Decodable, ProfileRepresentable {
    let id: Int
    let firstName: String
    let lastName: String
    let photo100: String
    
    var name: String { return firstName + " " + lastName}
    var photo: String { return photo100 }
}

struct Groups: Decodable, ProfileRepresentable {
    var photo: String { return photo100 }
    
    let id: Int
    let name: String
    let photo100: String
}
