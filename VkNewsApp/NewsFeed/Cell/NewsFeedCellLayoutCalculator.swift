
//  Created by Семен Гайдамакин on 19.06.2023.
//

import Foundation
import UIKit


struct Sizes: FeedCellSizes {
    var postLabelFrame: CGRect
    
    var attachmentFrame: CGRect
    
    var bottomViewFrame: CGRect
    
    var totalHieght: CGFloat
}

                                              
protocol FeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?, photoAttchmant: FeedCellPhotoAttachmentViewModel?) -> FeedCellSizes
}

final class FeedCellLayoutCalculator: FeedCellLayoutCalculatorProtocol {
   
    private var screenWidth: CGFloat
  
    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    
    func sizes(postText: String?, photoAttchmant: FeedCellPhotoAttachmentViewModel?) -> FeedCellSizes {
        
        let cardViewWidth = screenWidth - Constants.cardInserts.left - Constants.cardInserts.right
        
        //MARK: - Работа с postLabelFrame
        var postLabelFrame = CGRect(origin: CGPoint(x: Constants.postLabelInsets.left, y: Constants.postLabelInsets.top) , size: CGSize.zero)
        
        if let text = postText, !text.isEmpty {
            let width = cardViewWidth - Constants.postLabelInsets.left - Constants.postLabelInsets.right
            let height = text.height(width: width, font: Constants.postLabelFont)
            
            postLabelFrame.size = CGSize(width: width, height: height)
        }
        
        //MARK: - Работа с attachmentFrame
        let attachmentTop = postLabelFrame.size == CGSize.zero ? Constants.postLabelInsets.top : postLabelFrame.maxY + Constants.postLabelInsets.bottom
        var attachmentFrame = CGRect(origin: CGPoint(x: 0, y: attachmentTop), size: CGSize.zero)
        
        if let attachment = photoAttchmant {
            print("Фотография, height: \(attachment.height), width: \(attachment.width) \n\n")
            let ratio = Float(attachment.height) / Float(attachment.width)
            print("ratio \(ratio)")
            attachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * CGFloat(ratio))
        }
        
        //MARK: - Работа с bottomViewFrame
        let bottomViewTopY = max(postLabelFrame.maxY, attachmentFrame.maxY)
        
        let bottomViewFrame = CGRect(origin: CGPoint(x: 0, y: bottomViewTopY), size: CGSize(width: cardViewWidth, height: Constants.bottomViewHeight))
        
        
        //MARK: - Работа с totalHeight
        
        let totalHeight = bottomViewFrame.maxY + Constants.cardInserts.bottom
        
        return Sizes(postLabelFrame: postLabelFrame, attachmentFrame: attachmentFrame, bottomViewFrame: bottomViewFrame, totalHieght: totalHeight)
    }
 
}

