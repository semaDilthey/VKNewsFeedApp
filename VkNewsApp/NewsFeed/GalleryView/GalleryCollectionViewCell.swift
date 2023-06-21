//
//  GalleryCollectionViewCell.swift
//  VkNewsApp
//
//  Created by Семен Гайдамакин on 21.06.2023.
//

import Foundation
import UIKit

class GalleryCollectionViewCell : UICollectionViewCell {
    
    static let reuseID = "GalleryCollectionViewCell"
    
    let myImageView : WebImageView = {
        let view = WebImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.backgroundColor = .red
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(myImageView)
        
        
        //myImageView contraints
        myImageView.fillSuperview()
    }
    
    override func prepareForReuse() {
        myImageView.image = nil
    }
    
    func set(imageURL: String?) {
        myImageView.set(imageURL: imageURL)
    }
    // все корректировки интерфейса желательно делать тут
    override func layoutSubviews() {
        super.layoutSubviews()
        myImageView.layer.masksToBounds = true
        myImageView.layer.cornerRadius = 10
        self.layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 2.5, height: 4)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
