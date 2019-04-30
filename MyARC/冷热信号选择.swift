//
//  冷热信号选择.swift
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
class DemoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        
        
    }
    
    
    //也许你只是想两个观察者共享一次网络请求带回的Event
    //但事实上这里会发生两次网络请求, 但这不是一个bug, 这是一个feature.
    //SignalProducer的一个特性是, 每次被订阅就会执行一次初始化时保存的闭包
    func useSignalProducer() {
        
        let producer = SignalProducer<Int,NoError>{(innerObser,_) in
            self.fetchData(completionHandler: { (data, error) in
                innerObser.send(value: 1)
                innerObser.send(value: 2)
            })
        }
        
        producer.startWithValues { (vale) in
            print("did recived value \(vale)")
        }
        
        producer.startWithValues { (value) in
             print("did recived value \(value)")
        }
        
        //发起网络请求 did received value: 1
        //发起网络请求 did received value: 2
        
    }
    //所以如果你有类似一次执行, 多处订阅的需求, 你应该选择Signal而不是SignalProducer
    func useSignal(){
        let sgnalTuple = Signal<Int,NoError>.pipe()
        self.fetchData { (data, error) in
            sgnalTuple.input.send(value: 1)
        }
        
        sgnalTuple.output.observeValues { (value) in
            print("did received value: \(value)")
        }
    }
    
    func fetchData(completionHandler: (Int, Error?) -> ()) {
        print("发起网络请求")
        completionHandler(1, nil)
    }
}
