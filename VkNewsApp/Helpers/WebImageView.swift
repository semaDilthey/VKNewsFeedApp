//
//  WebImageView.swift
//  VkNewsApp
//
//  Created by Семен Гайдамакин on 16.06.2023.
//

import Foundation
import UIKit


// При использовании ImageView который грузит из инета, обязательно подписывать его под класс WebImageView!
class WebImageView : UIImageView {
    
    func set(imageURL: String?) {
        // функционал позволит закгружать картинки с инета
        guard let imageURL = imageURL, let url = URL(string: imageURL) else { return }
        
        // проверяем есть ли картинка в кэше
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cachedResponse.data)
            print("from cache")
            return // Если каритнка уже есть в кэше, то загрузка дальше не идет
        }
       
        print("from internet")
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                if let data = data, let response = response {
                self?.image = UIImage(data:  data)
                self?.handleLoadedImage(data: data, response: response) // сохраням картинку в кэш
                }
            }
        }
        dataTask.resume()
    }
    
    private func handleLoadedImage(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data) // получаем некий ответ на наш запрос
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL)) // и уже этот ответ передаем в storeCached который хранит в себе кэшированый ответ для указанного запроса
        
    }
}
