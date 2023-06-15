

import UIKit

enum NewsFeed {

  enum Model {
    struct Request {
        enum RequestType {

            case getNewsFeed
        }
    }
      
    struct Response {
        enum ResponseType {
            case presentNewsFeed(feed: FeedResponse)
            
        }
    }
      
    struct ViewModel {
        enum ViewModelData {

            case displayNewsFeed(feedViewModel: FeedViewModel)
        }
    }
  }
}


struct FeedViewModel {
    struct Cell: FeedCellViewModel {
        
        var name: String
        var date: String
        var text: String?
        var likes: String?
        var comments: String?
        var shares: String?
        var views: String?
        var iconUrlString: String
    }
    let cells: [Cell]
}
