

import UIKit

protocol NewsFeedBusinessLogic {
  func makeRequest(request: NewsFeed.Model.Request.RequestType)
}


class NewsFeedInteractor: NewsFeedBusinessLogic, NewsFeedDataStore {
    
    var presenter: NewsFeedPresentationLogic?
    var service: NewsFeedService?
    
    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
  
    func makeRequest(request: NewsFeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsFeedService()
        }
        
        switch request {
            
//2. Когда срабатывает этот кейс во VC, fetcher убдет вызывать getFeed, который показыает все данные из инета уже после JSON декодера в модели FeedResponse
        case .getNewsFeed:
            fetcher.getFeed { [weak self] (feedResponse) in
                
                feedResponse?.groups.map({ (group) in
                    print("\(group)")
                })
                
//3. эти данные из FeedResponse уже передаем в кейс презентера .presentNewsFeed . У этого кейса добавлено ассоциативное значение, чтобы можно было передать это наши данные -> Presenter
                guard let feedResponse = feedResponse else { return }
                self?.presenter?.presentData(response: .presentNewsFeed(feed: feedResponse))
                
                
            }
        }
    }
}
