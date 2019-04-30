//
//  Extension.swift
//  MyARC
//
//  Created by ZhuDabin on 2019/4/26.
//  Copyright © 2019年 ZhuDabin. All rights reserved.
//

import Result
import ReactiveCocoa
import ReactiveSwift

typealias NSignal<T> = ReactiveSwift.Signal<T, NoError>
typealias AnySignal = ReactiveSwift.Signal<Any?, NoError>
typealias APISignal<T> = ReactiveSwift.Signal<T, APIError>
typealias AnyAPISignal = ReactiveSwift.Signal<Any?, APIError>

typealias Producer<T> = ReactiveSwift.SignalProducer<T, NoError>
typealias AnyProducer = ReactiveSwift.SignalProducer<Any?, NoError>
typealias APIProducer<T> = ReactiveSwift.SignalProducer<T, APIError>
typealias AnyAPIProducer = ReactiveSwift.SignalProducer<Any?, APIError>

typealias NAction<I, O> = ReactiveSwift.Action<I, O, NoError>
typealias AnyAction = ReactiveSwift.Action<Any?, Any?, NoError>
typealias APIAction<O> = ReactiveSwift.Action<[String: String]?, O, APIError>
typealias AnyAPIAction = ReactiveSwift.Action<Any?, Any?, APIError>

typealias ButtonAction = ReactiveCocoa.CocoaAction<UIButton>

extension SignalProducer where Error == APIError {
    
    @discardableResult
    func startWithValues(_ action: @escaping (Value) -> Void) -> Disposable {
        return start(Signal.Observer(value: action))
    }
}

extension CocoaAction {
    
    public convenience init<Output, Error>(_ action: Action<Any?, Output, Error>) {
        self.init(action, input: nil)
    }
}


extension String {
    
    public var url: URL? {
        return URL(string: self)
    }
    
    public var data: Data? {
        return data(using: String.Encoding.utf8)
    }
    
    public var image: UIImage? {
        return UIImage(named: self)
    }
    
    public var isValidPhoneNum: Bool {
        
        /**
         * 手机号码
         * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
         * 联通：130,131,132,152,155,156,185,186
         * 电信：133,1349,153,180,189
         */
        let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
        
        /**
         * 中国移动：China Mobile
         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
         */
        let cm = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        
        /**
         * 中国联通：China Unicom
         * 130,131,132,152,155,156,185,186
         */
        let cu = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        
        /**
         * 中国电信：China Telecom
         * 133,1349,153,180,189
         */
        let ct = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
        
        return NSPredicate(format: "SELF MATCHES %@", mobile).evaluate(with: self) ||
            NSPredicate(format:"SELF MATCHES %@", cm).evaluate(with: self) ||
            NSPredicate(format:"SELF MATCHES %@", cu).evaluate(with: self) ||
            NSPredicate(format:"SELF MATCHES %@", ct).evaluate(with: self)
    }
}

extension UIImage {
    
     class func imageFromColor(color: UIColor, viewSize: CGSize) -> UIImage{
        
        let rect: CGRect = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        context.setFillColor(color.cgColor)
        
        context.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsGetCurrentContext()
        
        return image!
        
    }
}
