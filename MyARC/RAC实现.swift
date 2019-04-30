//
//  RAC实现.swift
//  MyARC
//
//  Created by ZhuDabin on 2019/4/25.
//  Copyright © 2019年 ZhuDabin. All rights reserved.
//

import Foundation

//Signal.swift
//Signal只有一个孤零零的core属性一个设置core属性的初始化函数以及一个调用core.observe的observe函数
//Signal只是Core的一个壳

//Core里面最重要的属性就是这个State. State的作用有两个:
//一个是指示信号的状态, 另一个就是上文我提到过的保存信号订阅者添加进来的Observer对象

//Observer是Event的处理逻辑封装, 这里我们添加并保存了Observer(也就是保存了Event的处理逻辑),
// 接下来需要的就是在合适的时机执行这些Observer内部的处理逻辑. 这部分代码对应Core.send(_ event: Event)

// pipe()函数会通过一个generator: (Observer, Lifetime)闭包去创建Core对象
//然后通过这个Core对象去创建Signal, pipe()函数通过generator闭包捕获了Core.init()中的innerObserver对象, 而这个InnerObserver对象的_send指向的其实是Core.send函数. 最后pipe()将创建完成Signal和InnerObserver打包返回.

