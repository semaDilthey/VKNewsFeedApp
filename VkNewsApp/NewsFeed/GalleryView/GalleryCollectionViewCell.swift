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
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .green
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(myImageView)
        backgroundColor = .purple
        
        //myImageView contraints
        myImageView.fillSuperview()
    }
    
    override func prepareForReuse() {
        myImageView.image = nil
    }
    
    func set(imageURL: String?) {
        myImageView.set(imageURL: imageURL)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
