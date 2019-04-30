//
//  操作符.swift
//  MyARC
//
//  Created by ZhuDabin on 2019/4/26.
//  Copyright © 2019年 ZhuDabin. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result

class OperatorDemoVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //<~操作符. <~非常有用, 而且实现也非常的简单,
        //<~的左边是绑定目标(BindingTargetProvider), 右边则是数据源(BindingSource)
        //<~会把右边数据源的发送出的Value直接绑定到左边的目标上
        
        
        let errorLabel = UILabel()
        let sendButton = UIButton()
        let phoneNumerTextField = UITextField()
        
        let errorText = MutableProperty("")
        let validPhoneNumer = MutableProperty("")
        
        errorLabel.reactive.text <~ errorText
        sendButton.reactive.isEnabled <~ errorText.map{$0.count==0}
        sendButton.reactive.backgroundColor <~ errorText.map{$0.count==0 ? UIColor.white : UIColor.red}
        phoneNumerTextField.reactive.text <~ validPhoneNumer //绑定有效输入到输入框
        
        validPhoneNumer <~ phoneNumerTextField.reactive.continuousTextValues.map({ (text) -> String in
            let phoneNumber = (text ?? "").suffix(11)//1: 最多输入 11个数字
            let isValidPhoneNum = NSPredicate(format: "SELF MATCHES %@", "正则表达式...").evaluate(with: phoneNumber) //2. 检查手机格式是否正确
            errorText.value = isValidPhoneNum ? "手机号格式不正确" : "" //2. 格式不正确显示错误信息
            return String(phoneNumber) //3. 返回截取后的有效输入
        })
        
        
    }
}
