//
//  RegisterViewModel.swift
//  MyARC
//
//  Created by ZhuDabin on 2019/4/27.
//  Copyright © 2019年 ZhuDabin. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result

private let InValidAccount = "手机号码格式不对"
private let InvalidPassword = "密码格式不对"
private let InvalidVerifyCode = "验证码格式不对"

class RegisterViewModel: NSObject {
    
    var validAccount = MutableProperty("")
    var validPassword = MutableProperty("")
    var validEnterPassword = MutableProperty("")
    var valiVerifyCode = MutableProperty("")
    var errorText = MutableProperty("")
    private var timer: Timer?
    private var time = MutableProperty(60)
    private(set) var verifyCodeText = MutableProperty("验证码")
    var errors = (account: InValidAccount,password: InvalidPassword,verfiyCode:InvalidVerifyCode)
    
    func setInput(accountInput: NSignal<String?>,passwordInput: NSignal<String?>,ensurePasswordInput: NSignal<String?>,verifyCodeInput: NSignal<String?>){
        //账号: 11位手机
        validAccount <~ accountInput.map({ (text) -> String in
            let account = String((text ?? "").suffix(11))
            self.errors.account = account.isValidPhoneNum ?  "" : InValidAccount
            return account
        })
        //
        validPassword <~ passwordInput.map({ (text) -> String in
           let password = String((text ?? "").suffix(16))
           let isValidPassword = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-zA-Z0-9].*)(?=.*[a-zA-Z\\W].*)(?=.*[0-9\\W].*).{6,16}$")
            self.errors.password = isValidPassword.evaluate(with: password) ? "" : InvalidPassword
             return password
        })
        //
        validEnterPassword <~ ensurePasswordInput.map({
            return String(($0 ?? "").suffix(16))
        })
        
        valiVerifyCode <~ verifyCodeInput.map({ [unowned self] (text) -> String in
            let verifyCode = String((text ?? "").suffix(6))
            let isValidVerifyCode = NSPredicate(format: "SELF MATCHES %@", "\\w+")
            self.errors.verfiyCode = isValidVerifyCode.evaluate(with: verifyCode) ? "" : InvalidVerifyCode
            return verifyCode
            
        })
    }
    
    //获取验证码
     lazy var getVerifyCodeAction = AnyAPIAction(enabledIf: self.enableGetVerityCode) { [unowned self] _ -> AnyAPIProducer in
        return self.getVeriftyCodeProducer
    }

    var getVeriftyCodeProducer: AnyAPIProducer {
        return  SignalProducer<Any?,APIError>.init({ () -> Any? in
            return true
        }).on(value: { [unowned self] (value) in
            self.timer?.invalidate()
            self.time.value = 60
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                self.verifyCodeText.value = self.time.value>0 ? String(self.time.value)+"s" : "验证码"
                if(self.time.value<=0){timer.invalidate()  }
                self.time.value -= 1
            })
        })
    }
    
     var enableGetVerityCode: Property<Bool> {
        return Property.combineLatest(time,validAccount).map({ [unowned self] (time, _) -> Bool in
            return self.errors.account != InValidAccount && (time<=0 || time>=60)
        })
    }
    
    //提交
    lazy var submitAction = AnyAPIAction(enabledIf: self.enableSubmit) { [unowned self] (_) -> SignalProducer<Any?, APIError> in
        return  SignalProducer<Any?,APIError>.init({ () -> Any? in
            return true
        })
    }
    
    var enableSubmit : Property<Bool> {
        return Property.combineLatest(validAccount,validPassword,validEnterPassword,valiVerifyCode).map({ [unowned self] (account, password, ensurePassword, verifyCode) -> Bool in
            
            if self.errors.account.count > 0 {
                self.errorText.value = self.errors.account
            } else if self.errors.password.count > 0 {
                self.errorText.value = self.errors.password
            } else if password != ensurePassword  {
                self.errorText.value = "两次输入的密码不一致"
            } else if self.errors.verfiyCode.count > 0 {
                self.errorText.value = self.errors.verfiyCode
            } else {
                self.errorText.value = ""
            }
            return self.errorText.value.count == 0
        })
    }
    
}



