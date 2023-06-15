
import UIKit

protocol NewsFeedPresentationLogic {
    func presentData(response: NewsFeed.Model.Response.ResponseType)
}

class NewsFeedPresenter: NewsFeedPresentationLogic {
    weak var viewController: NewsFeedDisplayLogic?
  
    func presentData(response: NewsFeed.Model.Response.ResponseType) {
        
        switch response {
// 4. Преобразовываем feedResponse для отображения прям в интерфейс. В интерфейсе все выглядит как ячейки, а ячейки заполняются в соответствие со структурой Cell структуры FeedViewModel. А информация каждой ячейки уже будет храниться в массиве под названием cells
        case .presentNewsFeed(feed: let feed):
        
            let cells = feed.items.map { (feedItem) in
                cellViewModel(from: feedItem)
            }
            
            let feedViewModel = FeedViewModel.init(cells: cells)
            viewController?.displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData.displayNewsFeed(feedViewModel: feedViewModel))
        }
    }
    
    
    // Заполняем ячейку данными
    private func cellViewModel(from feedItem: FeedItem) -> FeedViewModel.Cell {
        return FeedViewModel.Cell.init(name: "Future name",
                                       date: String(feedItem.date),
                                       text: feedItem.text,
                                       likes: String(feedItem.likes?.count ?? 0),
                                       comments: String(feedItem.comments?.count ?? 0),
                                       shares: String(feedItem.reposts?.count ?? 0),
                                       views: String(feedItem.views?.count ?? 0),
                                       iconUrlString: "")
    }
}
