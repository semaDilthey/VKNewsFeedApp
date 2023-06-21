//
//  RowLayout.swift
//  VkNewsApp
//
//  Created by Семен Гайдамакин on 21.06.2023.
//

import Foundation
import UIKit


protocol RowLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, photoAtIndexPath indexPath: IndexPath) -> CGSize
}


class RowLayout: UICollectionViewLayout {
    
    weak var delegate: RowLayoutDelegate?
    
    static var numberOfRows = 1 // число рядов в коллекшен вью
    fileprivate var cellPadding: CGFloat = 8 // отступы по краям
    
    // маслив для кэширования вычисляемых аттрибутов, т.е размер и расположение ячейки
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    // константы высоты и ширины
    fileprivate var contentWidth: CGFloat = 0
    fileprivate var contentHeight: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        
        let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.left + insets.right)
    }
    
    // функция уже возвращает наружу размер коллекции
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    
    //MARK: - 80% математики
    override func prepare() {
        
        contentWidth = 0
        cache = []
        guard cache.isEmpty == true, let collectionView = collectionView else { return }
        
        // достаем все фотографии
        var photos = [CGSize]()
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            guard let photoSize = delegate?.collectionView(collectionView, photoAtIndexPath: indexPath) else { return print("AAAA") }
            photos.append(photoSize)
        }
        
        let superViewWidth = collectionView.frame.width
        // достаем фотку с самым маленьким расширением чтобы вычислить ее высоту
        guard var rowHeight = RowLayout.rowHeightCounter(superViewWidth: superViewWidth, photosArray: photos) else { return }
        rowHeight = rowHeight / CGFloat(RowLayout.numberOfRows)
        // для каждой фотографии находим соотношение сторон
        let photosRatios = photos.map { $0.height / $0.width}
        
        var offsetY = [CGFloat]()
        for row in 0 ..< RowLayout.numberOfRows {
            offsetY.append(CGFloat(row) * rowHeight)
        }
        
        var offsetX = [CGFloat](repeating: 0, count: RowLayout.numberOfRows)
        
        var row = 0
        // для каждой ячейки задаем свой размер, а также фиксируем ее с помощью offsetX offsetY
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            let ratio = photosRatios[indexPath.row]
            let width = rowHeight / ratio
            let frame = CGRect(x: offsetX[row], y: offsetY[row], width: width, height: rowHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.frame = insetFrame
            cache.append(attribute)
            
            contentWidth = max(contentWidth, frame.maxX)
            offsetX[row] = offsetX[row] + width
            row = row < (RowLayout.numberOfRows - 1) ? (row + 1) : 0
        }
    }
        // Метод высчитывающий высоту одной секции на основе
        static func rowHeightCounter(superViewWidth: CGFloat, photosArray: [CGSize]) -> CGFloat? {
            var rowHeight: CGFloat
            
            let photoWidthMinRatio = photosArray.min { (first, second) -> Bool in
                (first.height / first.width) < (second.height / second.width)
            }
            guard let myPhotoWithMinRatio = photoWidthMinRatio else { return nil }
            
            let difference = superViewWidth / myPhotoWithMinRatio.width
            
            rowHeight = myPhotoWithMinRatio.height * difference
            rowHeight = rowHeight * CGFloat(RowLayout.numberOfRows) // rowHeight уже увеличивается до размера коллекшена
            return rowHeight
        }
        
    
    
    //MARK: - Эти 2 метода пишем всегда. Грубо говоря шаблонный код
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attribute in cache {
            if attribute.frame.intersects(rect) {
                visibleLayoutAttributes.append(attribute)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.row]
    }
}

