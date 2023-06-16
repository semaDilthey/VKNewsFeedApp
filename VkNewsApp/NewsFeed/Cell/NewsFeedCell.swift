

import Foundation
import UIKit

protocol FeedCellViewModel {
    var name: String { get }
    var date: String { get }
    var text: String? { get }
    var likes: String? { get }
    var comments: String? { get }
    var shares: String? { get }
    var views: String? { get }
    
    var iconUrlString: String { get }
    var photoAttachment: FeedCellPhotoAttachmentViewModel? { get }
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


extension NewsFeedCell {
    // реальные элементы получаются реальные данные
    func set(viewModel: FeedCellViewModel) {
        iconImageView.set(imageURL: viewModel.iconUrlString)
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
        postLabel.text = viewModel.text
        likesLabel.text = viewModel.likes
        commentsLabel.text = viewModel.comments
        sharesLabel.text = viewModel.shares
        viewsLabel.text = viewModel.views
        
        if let photoAttachment = viewModel.photoAttachment {
            postImageView.set(imageURL: photoAttachment.photoURLString)
            postImageView.isHidden = false
        } else {
            postImageView.isHidden = true
        }
    }
}
