//
//  Constants.swift
//  VkNewsApp
//
//  Created by Семен Гайдамакин on 19.06.2023.
//

import Foundation
import UIKit

struct Constants {
    static let cardInserts = UIEdgeInsets(top: 0, left: 8, bottom: 20, right: 8)
    static let topViewHeight : CGFloat = 52
    static let postLabelInsets = UIEdgeInsets(top: 8 + Constants.topViewHeight + 8, left: 8, bottom: 8, right: 8)
    static let postLabelFont = UIFont.systemFont(ofSize: 15)
    static let bottomViewHeight : CGFloat = 44
    
    
    // эти 2 для настройки констрейнтов
    static let bottomViewViewHeight: CGFloat = 44
    static let bottomViewViewWidth: CGFloat = 80
    
    static let bottomViewViewsIconSize: CGFloat = 24
    
    // для кнопки "Показать еще". Если 8 строк кода, то кнопка добавляется и текст сворачивается, если 6, то не добавляется
    static let minifiedPostLimitLines: CGFloat = 8
    static let minifiedPostLines: CGFloat = 6
        
    // Размер кнопки и отступы
    static let moreTextButtonSize = CGSize(width: 170, height: 30)
    static let moreTextButtonInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
}
