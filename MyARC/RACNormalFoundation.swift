//
//  RACNormalFoundation.swift
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

class NormalFoundationDemoViewController: UIViewController {
    typealias NSignal<T> = Signal<T,NoError>
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        useMap()
        useOn()
        useTakeUntil()
        useTakeFrist()
        useMerge()
        useCombineLatest()
    }
    
    
    
    //map
    func useMap() {
        let (signal,sender) =  NSignal<Int>.pipe()
        signal.map {return "xxxx\($0)"}.observeValues { (value) in
            print(value)
        }
        sender.send(value: 1)
    }
    
    //on 在信号信号发送事件和订阅者收到事件之间插入一段处理逻辑,可以看作map的简洁版
    //这个函数的参数很多，但是默认都是nil，所以你只要关心自己需要的部分就行
    func useOn(){
        let (signal,sender) =  NSignal<Int>.pipe()
        signal.on(value:{(value) in
            print("on value: \(value)")
        }).observeValues { (value) in
            print("did received value: \(value)")
        }
        sender.send(value: 1)
    }
    
    //take(until:) 在takeSign发送Event之前，signal可以正常发送Event，一旦takeSignal开始
    //发送Event，signal就停止发送，takeSign相当于一个停止信号
    func useTakeUntil() {
        let (signal,sender) = NSignal<Int>.pipe()
        let (takeSignal,takeSender) = NSignal<()>.pipe()
        signal.take(until: takeSignal).observeValues { (value) in
            print(value)
        }
        
        sender.send(value: 1)
        takeSender.send(value: ())
        sender.send(value: 2)
        
        //只输出 1
    }
    
    //take(first:) 只取最初N次的Event
    func useTakeFrist() {
        let (signal,sender) = NSignal<Int>.pipe()
        signal.take(first: 2).observeValues { (value) in
            print("did received value: \(value)")
        }
        
        sender.send(value: 1)
        sender.send(value: 2)
        sender.send(value: 3)
        sender.send(value: 4)
        //只接收 1，2
    }
    
    //merge
    //是把多个信号合并一个信号，任何一个信号有Event的时候,这个新信号就会发送
    func useMerge(){
        let (signal1,sender1) = NSignal<Int>.pipe()
        let (signal2,sender2) = NSignal<Int>.pipe()
        let (signal3,sender3) = NSignal<Int>.pipe()
        Signal.merge(signal1,signal2,signal3).observeValues { (value) in
            print("did received value: \(value)")
        }
        sender1.send(value: 1)
        sender2.send(value: 2)
        sender3.send(value: 3)
    }
    
    //combineLatest
    //把多个信号组合为一个新信号，新信号的Event是各个信号的最新的Event的组合
    //"组合"意味着每个信号都至少有发送过一次Event, 毕竟组合的每个部分都要有值
    //所以, 如果有某个信号一次都没有发送过Event, 那么这个新信号什么也不会发送
    func useCombineLatest()  {
        
        let (signal1, innerObserver1) = NSignal<Int>.pipe()
        let (signal2, innerObserver2) = NSignal<Int>.pipe()
        let (signal3, innerObserver3) = NSignal<Int>.pipe()
        
        Signal.combineLatest(signal1, signal2, signal3).observeValues { (tuple) in
            print("received value: \(tuple)")
        }
        
        
        innerObserver1.send(value: 1)
        innerObserver2.send(value: 2)
        innerObserver3.send(value: 3)
        innerObserver1.send(value: 11)
        innerObserver2.send(value: 22)
        innerObserver2.send(value: 33)
        
        //输出：
        //received value: (1, 2, 3)
        //received value: (11, 2, 3)
        //received value: (11, 22, 3)
        //received value: (11, 22, 33)
    }
    
    
    //zip
    //新信号的Event是各个信号的最新的Event的进行拉链式组合
    //拉链的左右齿必须对齐才能拉上, 这个函数也是一样的道理. 只有各个信号发送Event的次数相同(对齐)时, 新信号才会发送组合值
    // 如果有信号未发送那么什么也不会发生.
    func useZip()  {
        
        let (signal1, innerObserver1) = NSignal<Int>.pipe()
        let (signal2, innerObserver2) = NSignal<Int>.pipe()
        let (signal3, innerObserver3) = NSignal<Int>.pipe()
        
        Signal.zip(signal1, signal2, signal3).observeValues { (tuple) in
            print("received value: \(tuple)")
        }
        
        innerObserver1.send(value: 1)
        innerObserver2.send(value: 2)
        innerObserver3.send(value: 3)
        
        //输出: received value: (1, 2, 3)
        
        
        innerObserver1.send(value: 111)
        innerObserver2.send(value: 222)
        //没有输出
        
    }
}



