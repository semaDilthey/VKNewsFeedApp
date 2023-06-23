

import UIKit

enum NewsFeed {

  enum Model {
    struct Request {
        enum RequestType {
            case getNewsFeed
            case revealPostIds(postId: Int)
            case getUser
            case getNextBatch
        }
    }
      
    struct Response {
        enum ResponseType {
            case presentNewsFeed(feed: FeedResponse, revealedPostIds: [Int])
            case presentUserInfo(user: UserResponse?)
            case presentFooterLoader
            
        }
    }
      
    struct ViewModel {
        enum ViewModelData {
            case displayNewsFeed(feedViewModel: FeedViewModel)
            case displayUver(userViewModel: UserViewModel)
            case displayFooterLoader
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
        var photoAttachments: [FeedCellPhotoAttachmentViewModel]
        
        var sizes: FeedCellSizes
        
        var postId: Int
    }
    
    struct FeelCellPhotoAttachment: FeedCellPhotoAttachmentViewModel {
        var photoURLString: String?
        var width: Int
        var height: Int
    }
    let cells: [Cell]
    
    let footerTitle: String?
}

struct UserViewModel : TitleViewViewModel {
    
    var photoUrlString: String?
    
}
