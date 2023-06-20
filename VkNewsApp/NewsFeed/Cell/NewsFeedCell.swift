

import Foundation
import UIKit

// протокол отвечающий за визуальное заполнение ячеек. Никакие другие данные для этого не нужны
protocol FeedCellViewModel {
    var name: String { get }
    var date: String { get }
    var text: String? { get }
    var likes: String? { get }
    var comments: String? { get }
    var shares: String? { get }
    var views: String? { get }
    
    var iconUrlString: String { get }
    var photoAttachments: [FeedCellPhotoAttachmentViewModel] { get }
    
    var sizes: FeedCellSizes { get }
}


protocol FeedCellSizes {
    var postLabelFrame: CGRect { get }
    var attachmentFrame: CGRect { get }
    
    var bottomViewFrame: CGRect { get }
    var totalHieght: CGFloat { get }
    
    var moreTextButtonFrame: CGRect { get }
}


protocol FeedCellPhotoAttachmentViewModel {
    var photoURLString: String? { get }
    var width: Int { get }
    var height: Int { get }
}


class NewsFeedCell: UITableViewCell {
    
    static let reuseID = "NewsFeedCell"
    
    @IBOutlet weak var iconImageView: WebImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var postImageView: WebImageView!
    
    
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var sharesLabel: UILabel!
    
    @IBOutlet weak var viewsLabel: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    
    override func prepareForReuse() {
        iconImageView.set(imageURL: nil)
        postImageView.set(imageURL: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
        iconImageView.clipsToBounds = true
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// Настройки для xib файла ячейки, для программной ячейки ищи в NewsFeedCodeCell
extension NewsFeedCell {
    // реальные элементы получаются реальные данные
//    func set(viewModel: FeedCellViewModel) {
//        iconImageView.set(imageURL: viewModel.iconUrlString)
//        nameLabel.text = viewModel.name
//        dateLabel.text = viewModel.date
//        postLabel.text = viewModel.text
//        likesLabel.text = viewModel.likes
//        commentsLabel.text = viewModel.comments
//        sharesLabel.text = viewModel.shares
//        viewsLabel.text = viewModel.views
//
//        postLabel.frame = viewModel.sizes.postLabelFrame
//        postImageView.frame = viewModel.sizes.attachmentFrame
//        bottomView.frame = viewModel.sizes.bottomViewFrame
//
//        if let photoAttachment = viewModel.photoAttachment {
//            postImageView.set(imageURL: photoAttachment.photoURLString)
//            postImageView.isHidden = false
//        } else {
//            postImageView.isHidden = true
//        }
//    }
}
