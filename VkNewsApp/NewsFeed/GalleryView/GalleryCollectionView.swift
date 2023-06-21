//
//  GalleryCollectionView.swift
//  VkNewsApp
//
//  Created by Семен Гайдамакин on 21.06.2023.
//

import Foundation
import UIKit

class GalleryCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout {
    
    var photos = [FeedCellPhotoAttachmentViewModel]()
    
    init() {
        let collectionViewLayout = RowLayout()
        super.init(frame: .zero, collectionViewLayout: collectionViewLayout)
        
        delegate = self
        dataSource = self
        
        backgroundColor = .white
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseID)
        
        if let collectionViewLayout = collectionViewLayout as? RowLayout {
            collectionViewLayout.delegate = self
        }
    }
    
    func set(photos: [FeedCellPhotoAttachmentViewModel]) {
        self.photos = photos
        contentOffset = CGPoint.zero
        reloadData()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
    
}


extension GalleryCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.reuseID, for: indexPath) as! GalleryCollectionViewCell
        cell.set(imageURL: photos[indexPath.row].photoURLString)
        return cell
    }
}

extension GalleryCollectionView: RowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, photoAtIndexPath indexPath: IndexPath) -> CGSize {
        let width = photos[indexPath.row].width
        let height = photos[indexPath.row].height
        return CGSize(width: width, height: height)
    }
    
    
}
