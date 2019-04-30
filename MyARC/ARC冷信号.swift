//
//  ARC冷信号.swift
//  MyARC
//
//  Created by ZhuDabin on 2019/4/25.
//  Copyright © 2019年 ZhuDabin. All rights reserved.
//

import Foundation

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result


class RACColdSignalViewControoller: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //SignalProducer是ReactiveSwift中冷信号的实现, 是第二种发送事件的途径
        //冷信号则是休眠中的事件发生器. 也就是说冷信号需要一个唤醒操作, 然后才能发送事件, 而这个唤醒操作就是订阅它
        baseUse1()
        baseUse2()
    }
    
    
    func baseUse1() {
        //1:通过SignalProducer.init(startHandler: (Observer, Lifetime) -> Void)创建SignalProduct
        let producer = SignalProducer<Int, NoError> { (innerObserver, lifetime) in
            lifetime.observeEnded({
                print("信号无效了 你可以在这里进行一些清理工作")
            })
            
            //4. 向外界发送事件
            innerObserver.send(value: 1)
            innerObserver.send(value: 2)
            innerObserver.sendCompleted()
       }
        //2:创建一个观察者封装事件处理逻辑
        let outerObserver = Signal<Int,NoError>.Observer { (value) in
            print("did received value: \(value)")
        }
        //3:添加观察者到SignalProducer
        producer.start(outerObserver)
    }
    
    
    
    func baseUse2() {
        //创建信号
        let producer = Producer<Int>{(innerObser, _) in
            innerObser.send(value: 1)
        }
        producer.startWithValues { (value) in
            print("did received value: \(value)")
        }
    }
    
    
    
    
}

