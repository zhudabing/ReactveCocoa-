//
//  KVO.swift
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


class KVODemoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        useReactiveFunction()
    }
    
    //reactive
    func useReactiveFunction()  {
        let tableView = UITableView()
        tableView.reactive.signal(forKeyPath: "contentSize").observeValues { (contentSize) in
            print(contentSize ?? 0)
        }
    }

}
