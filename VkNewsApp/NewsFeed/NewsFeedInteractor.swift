

import UIKit

protocol NewsFeedBusinessLogic {
  func makeRequest(request: NewsFeed.Model.Request.RequestType)
}


class NewsFeedInteractor: NewsFeedBusinessLogic, NewsFeedDataStore {
    
    var presenter: NewsFeedPresentationLogic?
    var service: NewsFeedService?
    
    private var revealedPostIds = [Int]()
    private var feedResponse: FeedResponse?
    
    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
  
    func makeRequest(request: NewsFeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsFeedService()
        }
        
        
        switch request {
            
//2. Когда срабатывает этот кейс во VC, fetcher убдет вызывать getFeed, который показыает все данные из инета уже после JSON декодера в модели FeedResponse
            
//3. эти данные из FeedResponse уже передаем в кейс презентера .presentNewsFeed . У этого кейса добавлено ассоциативное значение, чтобы можно было передать это наши данные -> Presenter
        case .getNewsFeed:
            fetcher.getFeed { [weak self] (feedResponse) in
                
                self?.feedResponse = feedResponse
                self?.presentFeed()
            }
            
        case .revealPostIds(postId: let postId):
            revealedPostIds.append(postId)
            
            presentFeed()
            print("111")
            
        }
    }
    
    private func presentFeed() {
        guard let feedResponse = feedResponse else { return }
        presenter?.presentData(response: NewsFeed.Model.Response.ResponseType.presentNewsFeed(feed: feedResponse, revealedPostIds: revealedPostIds))
    }
}
