

import UIKit

enum NewsFeed {

  enum Model {
    struct Request {
        enum RequestType {
            case getNewsFeed
            case revealPostIds(postId: Int)
        }
    }
      
    struct Response {
        enum ResponseType {
            case presentNewsFeed(feed: FeedResponse, revealedPostIds: [Int])
            
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
        var photoAttachment: FeedCellPhotoAttachmentViewModel?
        
        var sizes: FeedCellSizes
        
        var postId: Int
    }
    
    struct FeelCellPhotoAttachment: FeedCellPhotoAttachmentViewModel {
        var photoURLString: String?
        var width: Int
        var height: Int
    }
    let cells: [Cell]
}
