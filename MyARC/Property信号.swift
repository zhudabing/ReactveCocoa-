//
//  Property信号.swift
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
class DemoPropetyVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ReactiveSwift发送事件的第三种途径是Property/MutableProperty
        //从冷热信号的定义上来看, Property的行为应该属于热信号
        //但和上文的Signal不同, Property/MutableProperty只提供一种状态的事件
        let constant = Property(value: 1)
        // constant.value = 2  //error: Property(value)创建的value不可变
        print("initial value is: \(constant.value)")
        constant.producer.startWithValues { (value) in
            print("producer received: \(value)")
        }
        
        constant.signal.observeValues { (value) in
            print("producer received: \(value)")
        }
        
        
        
        let mutanleProperty  = MutableProperty(1)
        mutanleProperty.producer.startWithValues { //冷信号可以收到初始值value=1和2,3
            print("producer received \($0)")
        }
        mutanleProperty.signal.observeValues{ //热信号只能收到后续的变化值value=2,3
             print("producer received \($0)")
        }
        mutanleProperty.value = 2
        mutanleProperty.value = 3
        //Property的基本信息. 大家只需要知道Property.value不可设置
        //MutableProperty.value可设置. Property/MutableProperty内部有一个Producer一个Signal, 设置value即是在向这两个信号发送Value事件即可
    }
    
    
}
