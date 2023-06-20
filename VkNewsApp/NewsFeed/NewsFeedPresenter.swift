
import UIKit

protocol NewsFeedPresentationLogic {
    func presentData(response: NewsFeed.Model.Response.ResponseType)
}

class NewsFeedPresenter: NewsFeedPresentationLogic {
    
    weak var viewController: NewsFeedDisplayLogic?
    var cellLayoutCalculator: FeedCellLayoutCalculatorProtocol = FeedCellLayoutCalculator()
    
    // создаем для конвертации даты из форматы юнитекса
    let dateFormatter: DateFormatter = {
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU") // задаем локализауию
        dt.dateFormat = "d MMM 'в' HH:mm" // и формат
        return dt
    }()
  
    func presentData(response: NewsFeed.Model.Response.ResponseType) {
// 4. Преобразовываем feedResponse для отображения прям в интерфейс. В интерфейсе все выглядит как ячейки, а ячейки заполняются в соответствие со структурой Cell структуры FeedViewModel. А информация каждой ячейки уже будет храниться в массиве под названием cells
        switch response {
        case .presentNewsFeed(feed: let feed, let revealedPostIds): // здесь хранится наша data в параметре feed
            print(revealedPostIds)
            let cells = feed.items.map { (feedItem) in
                cellViewModel(from: feedItem, profiles: feed.profiles, groups: feed.groups, revealedPostIds: revealedPostIds)
            }
            
            let feedViewModel = FeedViewModel.init(cells: cells)
            viewController?.displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData.displayNewsFeed(feedViewModel: feedViewModel))
        }
    }
    
    
    // Заполняем ячейку данными и потом эту ячейку вставляем в функцию PresentData
    private func cellViewModel(from feedItem: FeedItem, profiles: [Profile], groups: [Groups], revealedPostIds: [Int]) -> FeedViewModel.Cell {
        
        let profiles = self.profile(for: feedItem.sourceId, profiles: profiles, groups: groups)
        
        let photoAttachment = self.photoAttachment(feedItem: feedItem)
        
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitile = dateFormatter.string(from: date)
        
        let isFullSized = revealedPostIds.contains(feedItem.postId)
        
        let sizes = cellLayoutCalculator.sizes(postText: feedItem.text, photoAttchmant: photoAttachment, isFullSizedPost: isFullSized)
        
        return FeedViewModel.Cell.init(name: profiles.name,
                                       date: dateTitile,
                                       text: feedItem.text,
                                       likes: String(feedItem.likes?.count ?? 0),
                                       comments: String(feedItem.comments?.count ?? 0),
                                       shares: String(feedItem.reposts?.count ?? 0),
                                       views: String(feedItem.views?.count ?? 0),
                                       iconUrlString: profiles.photo,
                                       photoAttachment: photoAttachment,
                                       sizes: sizes,
                                       postId: feedItem.postId)
    }
    
    private func profile(for sourceId: Int, profiles: [Profile], groups: [Groups]) -> ProfileRepresentable {
        let profilesOrGroups: [ProfileRepresentable] = sourceId >= 0 ? profiles : groups
        let normalSourceId = sourceId >= 0 ? sourceId : -sourceId
        let profileRepresentable = profilesOrGroups.first { (myProfileRepresentable) -> Bool in
            myProfileRepresentable.id == normalSourceId
        }
        return profileRepresentable!
    }
                                       
     private func photoAttachment(feedItem: FeedItem) -> FeedViewModel.FeelCellPhotoAttachment? {
            guard let photos = feedItem.attachments?.compactMap({ (attachment) in
                attachment.photo
            }), let firstPhoto = photos.first else {
                return nil
            }
            return FeedViewModel.FeelCellPhotoAttachment.init(photoURLString: firstPhoto.srcBIG, width: firstPhoto.width, height: firstPhoto.height)
        }
}
