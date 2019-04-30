//
//  ViewController.swift
//  MyARC
//
//  Created by ZhuDabin on 2019/4/24.
//  Copyright © 2019年 ZhuDabin. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result


class ViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        useObserveValue()
        
        self.view.backgroundColor = UIColor.white
        
        let btnKVO = UIButton(frame: CGRect(x: 10, y: 80, width: 100, height: 30))
        btnKVO.setTitle("KVO", for: .normal)
        btnKVO.setTitleColor(UIColor.black, for: .normal)
        btnKVO.layer.borderWidth = 1
        btnKVO.layer.borderColor = UIColor.black.cgColor
        view.addSubview(btnKVO)
        btnKVO.reactive.controlEvents(UIControl.Event.touchUpInside).observeValues { (send) in
            let kvoVC = KVODemoViewController()
            self.navigationController?.pushViewController(kvoVC, animated: true)
        }
        
    }
    
    
    /**基本应用**/
    func baseUse1() {
        //Signal是ReactiveSwift中的热信号，它是一直活跃着的，会主动将事件向外发送
        //不会等到有人订阅后才会发送，这就意味着，如果订阅晚于发送时机，那么订阅者是不会
        //收到订阅时机之前的事的
        //通常，你只有通过Signal.pipe()函数来初始化一个热信号，这个函数返回一个元组，元组的第一个
        //output(类型事Singal)，第二个值是input(类型是Observer)，我们通过output来订阅信号，通过
        //input来向input来发送信号
        let (signal,innerObserver) = Signal<Int,NoError>.pipe()
        
        let outerObserver1 = Signal<Int,NoError>.Observer(value: { (value) in
            print(value)
        }, failed: { (error) in }, completed: {
            print("complete")
        }) {}
        
        signal.observe(outerObserver1)
        
        innerObserver.send(value:1) //
        innerObserver.sendCompleted()//
    }
    
    /**简化基本应用**/
    typealias NSignal<T> = Signal<T,NoError>
    func baseUse2() {
        
        let (singal,sender) = NSignal<Int>.pipe()
        singal.observeValues { (value) in
            print(value)
        }
        sender.send(value: 1)
    }
    
    func useObserveValue() {
        //Singal.observeValue,这是Signal.observe的一个便利函数，作用是创建一个只处理value事件
        //的obsevrver并添加到Signal
        //类似的还有只处理Failed事件的Signal.observeFailed
        //处理所有事件的Signal.observeResult
        let view1 = View1()
        let model = ViewModel()
        view1.bind(model: model)
        model.sender.send(value: 1)
    }
    
}


class ViewModel: NSObject {
    let signal: Signal<Int, NoError>
    let sender: Signal<Int, NoError>.Observer
    
    override init() {
        (signal,sender) = Signal<Int, NoError>.pipe()
        super.init()
    }
}

class View1: UIView {

    func bind(model:ViewModel) {
        model.signal.observeValues { (value) in
            print("+++++ \(value) ++++++")
        }
    }
}
