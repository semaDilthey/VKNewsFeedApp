//
//  ViewController.swift
//  VkNewsApp
//
//  Created by Семен Гайдамакин on 14.06.2023.
//

import UIKit

class AuthViewController: UIViewController {

    private var authService: AuthService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
 
        authService = SceneDelegate.shared().authService
    }


   // кнопка входа в вк. Сперва делается проверка вошли ли мы уже или нет: В файле AuthService создается метод wakeUpSession
    @IBAction func signinTouch(_ sender: UIButton) {
        authService.wakeUpSession()
    }
    
    
}

