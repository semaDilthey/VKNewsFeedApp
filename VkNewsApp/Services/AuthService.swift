
//  Created by Семен Гайдамакин on 14.06.2023.
//

import Foundation
import VKSdkFramework


protocol AuthServiceDelegate: class /*class чтобы в будущем избежать утечек памяти и чтоб подписывать его только на классы */ {
    func authServiceShouldShow(viewController: UIViewController)
    func authServiceSignIn()
    func authServiceSignInDidFailed()
}

class AuthService: NSObject, VKSdkDelegate, VKSdkUIDelegate {
    
    weak var delegate: AuthServiceDelegate?
    
    var token: String? {
        return VKSdk.accessToken().accessToken
    }
    
    private let appId = "51676556" // id вк из приложения
    private let vkSdk: VKSdk 
    
    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        print("VKSds.initialize")
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
      print(#function)
        if result.token != nil {
            delegate?.authServiceSignIn()
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print(#function)
        delegate?.authServiceSignInDidFailed()
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print(#function)
        delegate?.authServiceShouldShow(viewController: controller)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
    
    // в этом методе уже прогоняются разные состояния как в SDK
    func wakeUpSession() {
        let scope = ["offline","wall", "friends"] // сюда записываем параметры к которым даем доступ
        VKSdk.wakeUpSession(scope) { [self] (state, error) in
            switch state {
            case .initialized:
                print("initialized")
                VKSdk.authorize(scope)
            case .authorized:
                print("authorized")
                delegate?.authServiceSignIn()
            default:
                delegate?.authServiceSignInDidFailed()
                
            }
        }
    }
}
