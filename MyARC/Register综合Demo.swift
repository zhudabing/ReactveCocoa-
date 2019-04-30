//
//  综合Demo.swift
//  MyARC
//
//  Created by ZhuDabin on 2019/4/26.
//  Copyright © 2019年 ZhuDabin. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class Demo2ViewController: UIViewController {
    
    let accountTF = UITextField()
    let passwordTF = UITextField()
    let ensurePasswordTF = UITextField()
    let verifyCodeTF = UITextField()
    let verifyCodeButton = UIButton()
    let errorLabel = UILabel()
    let submitButton = UIButton()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubview(accountTF)
        accountTF.frame = CGRect(x: 50, y: 100, width: 300, height: 40)
        accountTF.layer.borderWidth = 1
        accountTF.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        accountTF.layer.cornerRadius = 5
        accountTF.layer.masksToBounds = true
        accountTF.placeholder = " 手机号"
        
        view.addSubview(passwordTF)
        passwordTF.frame = CGRect(x: 50, y: 150, width: 300, height: 40)
        passwordTF.layer.borderWidth = 1
        passwordTF.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        passwordTF.layer.cornerRadius = 5
        passwordTF.layer.masksToBounds = true
        passwordTF.placeholder = " 密码：6~16位字母数字的组合"
        
        view.addSubview(ensurePasswordTF)
        ensurePasswordTF.frame = CGRect(x: 50, y: 200, width: 300, height: 40)
        ensurePasswordTF.layer.borderWidth = 1
        ensurePasswordTF.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        ensurePasswordTF.layer.cornerRadius = 5
        ensurePasswordTF.layer.masksToBounds = true
        ensurePasswordTF.placeholder = " 确认密码"
        
        view.addSubview(verifyCodeTF)
        verifyCodeTF.frame = CGRect(x: 50, y: 250, width: 200, height: 40)
        verifyCodeTF.layer.borderWidth = 1
        verifyCodeTF.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        verifyCodeTF.layer.cornerRadius = 5
        verifyCodeTF.layer.masksToBounds = true
        verifyCodeTF.placeholder = " 手机验证码"
        
        view.addSubview(verifyCodeButton)
        verifyCodeButton.frame = CGRect(x: 270, y: 250, width: 80, height: 40)
        verifyCodeButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        let image1 = UIImage.imageFromColor(color: #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), viewSize: CGSize(width: 300, height: 40))
        let image2 = UIImage.imageFromColor(color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), viewSize: CGSize(width: 300, height: 40))
        verifyCodeButton.setBackgroundImage(image1, for: .normal)
        verifyCodeButton.setBackgroundImage(image2, for: .disabled)
        verifyCodeButton.layer.cornerRadius = 20
        verifyCodeButton.layer.masksToBounds = true
        
        view.addSubview(errorLabel)
        errorLabel.frame = CGRect(x: 0, y: 300, width: UIScreen.main.bounds.width, height: 40)
        errorLabel.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        errorLabel.textAlignment = .center
    
        view.addSubview(submitButton)
        submitButton.frame = CGRect(x: 50, y: 350, width: 300, height: 40)
        submitButton.setBackgroundImage(image1, for: .normal)
        submitButton.setBackgroundImage(image2, for: .disabled)
        submitButton.setTitle("注册", for: .normal)
        submitButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        submitButton.layer.cornerRadius = 20
        submitButton.layer.masksToBounds = true
        submitButton.isEnabled = false
        viewModel = RegisterViewModel()

    }
    
    var viewModel: RegisterViewModel? {
        
        didSet {
            viewModel!.setInput(accountInput: accountTF.reactive.continuousTextValues,
                               passwordInput: passwordTF.reactive.continuousTextValues,
                               ensurePasswordInput: ensurePasswordTF.reactive.continuousTextValues,
                               verifyCodeInput: verifyCodeTF.reactive.continuousTextValues)

            accountTF.reactive.text <~ viewModel!.validAccount
            passwordTF.reactive.text <~ viewModel!.validPassword
            ensurePasswordTF.reactive.text <~ viewModel!.validEnterPassword
            verifyCodeButton.reactive.title <~ viewModel!.verifyCodeText
            verifyCodeButton.reactive.isEnabled <~ viewModel!.enableGetVerityCode
            verifyCodeButton.reactive.pressed = ButtonAction(viewModel!.getVerifyCodeAction)
            errorLabel.reactive.text <~ viewModel!.errorText.signal.skip(first: 2)
            submitButton.reactive.isEnabled <~ viewModel!.enableSubmit.signal.skip(first: 1)
            submitButton.reactive.pressed = ButtonAction(viewModel!.submitAction)
        }
    }

}
