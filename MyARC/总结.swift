//
//  总结.swift
//  MyARC
//
//  Created by ZhuDabin on 2019/4/28.
//  Copyright © 2019年 ZhuDabin. All rights reserved.
//

import Foundation
import Result
import ReactiveCocoa
import ReactiveSwift


class conclusion {
    //Event
    //Observer
    //Signal
    //SignalProduct
    //Property/MutableProperty
    //Action/CocoAction
    func useRAC(){
        /*******Signal热信号*********/
        //1:
        let (signalA,observerA) = Signal<Int,APIError>.pipe()
        let observer1 = Signal<Int,APIError>.Observer(value: { (value) in
            print(value)
        }, failed: nil, completed: nil, interrupted: nil)
        signalA.observe(observer1)
        observerA.send(value: 1)
        //2:Signal.observeValues, 这是Signal.observe的一个便利函数, 作用是创建一个只处理Value事件
        let (signalB,observerB) = Signal<Int,NoError>.pipe()
        signalB.observeValues { (value) in
            print(value)
        }
        observerB.send(value: 1)
        //3:与其他函数结合
        //map
        signalB.map {return "xxx\($0)"}.observeValues { (value) in
            print(value)
        }
        observerB.send(value: 1)
        //on 在信号发送事件和订阅者收到事件之间插入一段事件处理逻辑
        signalB.on(event: nil, failed: nil, completed: nil, interrupted: nil, terminated: nil, disposed: nil) { (value) in
            print("xxxxx\(value)xxxxxxx")
        }
        observerB.send(value: 2)
        //take(until)在takeSignal发送Event之前,signal可以正常发送Event,一旦takeSignal开始发送Event,signal就停止发送
        let (signalC,observerC) = Signal<(),NoError>.pipe()
        signalB.take(until: signalC).observeValues { (value) in
            print(value)
        }
        observerC.send(value: ())
        //take(first) 只取最初N次的Even
        signalB.take(first: 2).observeValues { (value) in
            print(value)
        }
        //merge把多个信号合并为一个新的信号，任何一个信号有Event的时就会这个新信号就会Event发送出来
        let (signalD,observerD) = Signal<Int,NoError>.pipe()
        Signal.merge(signalB,signalD).observeValues { (value) in
            print(value)
        }
        observerD.send(value: 3)
        //combineLatest 把多个信号组合为一个新信号，每个信号都至少有发送过一次Event,才会发出信号
        //zip 新信号的Event是各个信号的最新的Event的进行拉链式组合
        
        
        /**************SignalProduct冷信号*****************/
        //1:
        let producerA = SignalProducer<Int,NoError> {(observer,lifetime) in
            lifetime.observeEnded({
                print("信号无效，你可以在这里进行一些清理工作")
            })
            observer.send(value: 1)
        }
        producerA.start(observerB)//添加观察者
        //2:
        let producerB = SignalProducer<Int,NoError> {(observer,_) in
            observer.send(value: 4)
        }
        producerB.startWithValues { (value) in
            print(value)
        }
        //3:与其他函数和Signal一样
        //4: SignalProducer的一个特性是, 每次被订阅就会执行一次初始化时保存的闭包
        
        /********************Property/MutableProperty 热信号*********************/
        //1: Property/MutableProperty只提供一种状态的事件: Value.(虽然它有Completed状态)
        let constant = Property(value: 1)
        print(constant.value)
        constant.producer.startWithValues { (value) in
            print(value)
        }
        //2:
        let mutableProperty = MutableProperty("中国")
        mutableProperty.producer.startWithValues { (value) in
            print(value) //冷信号可以收到初始值‘中国’和'你好'
        }
        mutableProperty.signal.observeValues { (value) in
            print(value)//热信号只能收到'你好'
        }
        mutableProperty.value = "你好" //设置value就是在发送value的事件
        
        /******************绑定属性的操作符**************************/
        
        /***********************ACtion***************************/
        // 它并不直接发送事件, 而是生产信号, 由生产的信号来发送事件
        //Action是唯一一种可以接受订阅者输入的途径
        //1:
        // 创建一个Action 输入类型为[String: String]? 输出类型为Int 错误类型为APIError
        let action = Action<[String:String]?,Int,APIError>.init { (input) -> SignalProducer<Int, APIError> in
            print("input:",input)
            return SignalProducer<Int,APIError>{(observer,_) in
                observer.send(value: 1)
            }
        }
        //订阅Action的执行事件
        action.events.observe { (value) in
            print(value)
        }
        action.values.observeValues { (value) in
            print(value)
        }
        //执行action开始输出
        action.apply(["1":"xxxx"]).start()
        //在返回的Producer还未结束前执行Action是没用的, 只有上一个返回的Producer无效后, Action才能再次执行. (这个特性用来处理按钮的多次点击发送网络请求非常有用.)
        
        /******************CocoAction**********************/
        //ReactiveCocoa为一些可点击的UI控件(如UIButton, UIBarButtonItem...)都添加了一个reactive.pressed属性
        //我们可以通过设置reactive.pressed很方便的添加点击操作, 不过这个属性并不属于Action而是CocoaAction
        let executeButton = UIButton()
        let phoneTF = UITextField()
        
        let enable = MutableProperty(false)
        enable <~ phoneTF.reactive.continuousTextValues.map {return ($0 ?? "").count>0}
        let action1 = Action<String?,Int,APIError>{(input)->SignalProducer<Int,APIError> in
            print(input ?? "")
            return SignalProducer({ (observer,_) in
                observer.send(value: 1)
            })
        }
        //这样写 action得到的永远都是""
        //let cocoaAction1 = CocoaAction<UIButton>(action, input: nil)
        let cocoAction1 = CocoaAction<UIButton>.init(action1, input: phoneTF.text)
        let cocoAction2 = CocoaAction<UIButton>.init(action1) { (_) -> String? in
            return phoneTF.text
        }
        executeButton.reactive.pressed  = cocoAction1
        executeButton.reactive.pressed  = cocoAction2
//        executeButton.reactive.pressed = CocoaAction<UIButton>(action1) { _ in
//            return phoneTF.text //每次点击时都传入此时的phoneNumberTF.text作为action的输入
//        }
    }
}
