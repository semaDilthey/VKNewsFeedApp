

import UIKit

protocol NewsFeedBusinessLogic {
  func makeRequest(request: NewsFeed.Model.Request.RequestType)
}


class NewsFeedInteractor: NewsFeedBusinessLogic, NewsFeedDataStore {
    
    var presenter: NewsFeedPresentationLogic?
    var service: NewsFeedService?
  
    func makeRequest(request: NewsFeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsFeedService()
        }
        switch request {
            
//2. Когда срабатывает этот кейс во VC, fetcher убдет вызывать getFeed, который показыает все данные из инета уже после JSON декодера в модели FeedResponse
                        
//3. эти данные из FeedResponse уже передаем в кейс презентера .presentNewsFeed . У этого кейса добавлено ассоциативное значение, чтобы можно было передать это наши данные -> Presenter
            
        case .getNewsFeed:
            service?.getFeed(completion: { [weak self] (revealedPostIds, feed) in
                self?.presenter?.presentData(response: NewsFeed.Model.Response.ResponseType.presentNewsFeed(feed: feed!, revealedPostIds: revealedPostIds))
            })
       
        case .getUser:
            service?.getUser(completion: { [weak self] (user) in
                self?.presenter?.presentData(response: NewsFeed.Model.Response.ResponseType.presentUserInfo(user: user))
            })
            
        case .revealPostIds(postId: let postId):
            service?.revealPostIds(forPostId: postId, completion: { [weak self] (revealedPostIds, feed) in
                self!.presenter?.presentData(response: NewsFeed.Model.Response.ResponseType.presentNewsFeed(feed: feed!, revealedPostIds: revealedPostIds))
            })
        case .getNextBatch:
                self.presenter?.presentData(response: NewsFeed.Model.Response.ResponseType.presentFooterLoader)
                service?.getNextBatch(completion: { [weak self] (revealedPostIds, feed) in
                self?.presenter?.presentData(response: NewsFeed.Model.Response.ResponseType.presentNewsFeed(feed: feed!, revealedPostIds: revealedPostIds))
            })
        }
        
    }
    
}
