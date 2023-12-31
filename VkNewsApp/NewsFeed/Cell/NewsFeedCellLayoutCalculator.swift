
//  Created by Семен Гайдамакин on 19.06.2023.
//

import Foundation
import UIKit


struct Sizes: FeedCellSizes {
    
    var postLabelFrame: CGRect
    
    var moreTextButtonFrame: CGRect
    
    var attachmentFrame: CGRect
    
    var bottomViewFrame: CGRect
    
    var totalHieght: CGFloat
}

                                              
protocol FeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?, photoAttchmants: [FeedCellPhotoAttachmentViewModel], isFullSizedPost: Bool) -> FeedCellSizes
}

final class FeedCellLayoutCalculator: FeedCellLayoutCalculatorProtocol {
   
    private var screenWidth: CGFloat
  
    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    
    func sizes(postText: String?, photoAttchmants: [FeedCellPhotoAttachmentViewModel], isFullSizedPost: Bool) -> FeedCellSizes {
        
        var showMoreTExtButton: Bool = false
        
        let cardViewWidth = screenWidth - Constants.cardInserts.left - Constants.cardInserts.right
        
        //MARK: - Работа с postLabelFrame
        var postLabelFrame = CGRect(origin: CGPoint(x: Constants.postLabelInsets.left, y: Constants.postLabelInsets.top) , size: CGSize.zero)
        
        if let text = postText, !text.isEmpty {
            let width = cardViewWidth - Constants.postLabelInsets.left - Constants.postLabelInsets.right
            var height = text.height(width: width, font: Constants.postLabelFont)
            
            let limitHeight = Constants.postLabelFont.lineHeight * Constants.minifiedPostLimitLines //
            // проверка на то развернут ли пост или нет и если свернут то показывать кнопку, в противном случае кнопку убирать
            if !isFullSizedPost && height > limitHeight {
                height = Constants.postLabelFont.lineHeight * Constants.minifiedPostLines
                showMoreTExtButton = true
            }
            postLabelFrame.size = CGSize(width: width, height: height)
        }
        
        //MARK: - Работа с moreTextButtonFrame
        var moreTextButtonSize = CGSize.zero
        
        if showMoreTExtButton {
            moreTextButtonSize = Constants.moreTextButtonSize
        }
        
        let moreTextButtonOrigin = CGPoint(x: Constants.moreTextButtonInsets.left, y: postLabelFrame.maxY)
        
        let moreTextButtonFrame = CGRect(origin: moreTextButtonOrigin, size: moreTextButtonSize)
        
        //MARK: - Работа с attachmentFrame
        let attachmentTop = postLabelFrame.size == CGSize.zero ? Constants.postLabelInsets.top : moreTextButtonFrame.maxY + Constants.postLabelInsets.bottom
        var attachmentFrame = CGRect(origin: CGPoint(x: 0, y: attachmentTop), size: CGSize.zero)
        
//        if let attachment = photoAttchmants {
//            let ratio = Float(attachment.height) / Float(attachment.width)
//            attachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * CGFloat(ratio))
//        }
        
        if let attachment = photoAttchmants.first {
            let ratio = Float(attachment.height) / Float(attachment.width)
            if photoAttchmants.count == 1{
                attachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * CGFloat(ratio))
            } else if photoAttchmants.count > 1 {
//                attachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * CGFloat(ratio))
                var photos = [CGSize]()
                for photo in photoAttchmants {
                    let photoSize = CGSize(width: photo.width, height: photo.height)
                    photos.append(photoSize)
                }
                let rowHeight = RowLayout.rowHeightCounter(superViewWidth: cardViewWidth, photosArray: photos)
                attachmentFrame.size = CGSize(width: cardViewWidth, height: rowHeight!)
            }
        }
        
        //MARK: - Работа с bottomViewFrame
        let bottomViewTopY = max(postLabelFrame.maxY, attachmentFrame.maxY)
        
        let bottomViewFrame = CGRect(origin: CGPoint(x: 0, y: bottomViewTopY), size: CGSize(width: cardViewWidth, height: Constants.bottomViewHeight))
        
        
        //MARK: - Работа с totalHeight
        let totalHeight = bottomViewFrame.maxY + Constants.cardInserts.bottom
        
        return Sizes(postLabelFrame: postLabelFrame, moreTextButtonFrame: moreTextButtonFrame, attachmentFrame: attachmentFrame, bottomViewFrame: bottomViewFrame, totalHieght: totalHeight)
    }
 
}

