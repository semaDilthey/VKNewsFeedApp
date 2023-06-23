
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
            
            let footerTitle = String.localizedStringWithFormat(NSLocalizedString("newsFeed cells count", comment: ""), cells.count)
            let feedViewModel = FeedViewModel.init(cells: cells, footerTitle: footerTitle)
            viewController?.displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData.displayNewsFeed(feedViewModel: feedViewModel))
        case .presentUserInfo(user: let user):
            let userViewModel = UserViewModel.init(photoUrlString: user?.photo100)
            viewController?.displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData.displayUver(userViewModel: userViewModel))
        case .presentFooterLoader:
            viewController?.displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData.displayFooterLoader)
        }
    }
    
    
    // Заполняем ячейку данными и потом эту ячейку вставляем в функцию PresentData
    private func cellViewModel(from feedItem: FeedItem, profiles: [Profile], groups: [Groups], revealedPostIds: [Int]) -> FeedViewModel.Cell {
        
        let profiles = self.profile(for: feedItem.sourceId, profiles: profiles, groups: groups)
        
        let photoAttachments = self.photoAttachments(feedItem: feedItem)
        
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitile = dateFormatter.string(from: date)
        
        let isFullSized = revealedPostIds.contains(feedItem.postId)
        
        let sizes = cellLayoutCalculator.sizes(postText: feedItem.text, photoAttchmants: photoAttachments, isFullSizedPost: isFullSized)
        
        return FeedViewModel.Cell.init(name: profiles.name,
                                       date: dateTitile,
                                       text: feedItem.text,
                                       likes: formattedCounter(feedItem.likes?.count),
                                       comments: formattedCounter(feedItem.comments?.count),
                                       shares: formattedCounter(feedItem.reposts?.count),
                                       views: formattedCounter(feedItem.views?.count),
                                       iconUrlString: profiles.photo,
                                       photoAttachments: photoAttachments,
                                       sizes: sizes,
                                       postId: feedItem.postId)
    }
    
    private func formattedCounter(_ counter: Int?) -> String? {
        guard let counter = counter, counter > 0 else { return nil }
        var counterString = String(counter)
        if 4...6 ~= counterString.count {
            counterString = String(counterString.dropLast(3)) + "K"
        } else if counterString.count > 6 {
            counterString = String(counterString.dropLast(6)) + "M"
        }
        return counterString
    }
    
    private func profile(for sourceId: Int, profiles: [Profile], groups: [Groups]) -> ProfileRepresentable {
        let profilesOrGroups: [ProfileRepresentable] = sourceId >= 0 ? profiles : groups
        let normalSourceId = sourceId >= 0 ? sourceId : -sourceId
        let profileRepresentable = profilesOrGroups.first { (myProfileRepresentable) -> Bool in
            myProfileRepresentable.id == normalSourceId
        }
        return profileRepresentable!
    }
    
               // из всех фоток к опр посту выбирает первую и возвращает данные
     private func photoAttachment(feedItem: FeedItem) -> FeedViewModel.FeelCellPhotoAttachment? {
            guard let photos = feedItem.attachments?.compactMap({ (attachment) in
                attachment.photo
            }), let firstPhoto = photos.first else {
                return nil
            }
            return FeedViewModel.FeelCellPhotoAttachment.init(photoURLString: firstPhoto.srcBIG, width: firstPhoto.width, height: firstPhoto.height)
        }
    
    private func photoAttachments(feedItem: FeedItem) -> [FeedViewModel.FeelCellPhotoAttachment] {
        guard let attachments = feedItem.attachments else { return [] }
        
        return attachments.compactMap( { (attachment) -> FeedViewModel.FeelCellPhotoAttachment? in
            guard let photo = attachment.photo else { return nil }
            return FeedViewModel.FeelCellPhotoAttachment.init(photoURLString: photo.srcBIG, width: photo.width, height: photo.height)
        })
    }
}
