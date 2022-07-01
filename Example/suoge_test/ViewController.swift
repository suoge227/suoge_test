//
//  ViewController.swift
//  suoge_test
//
//  Created by suoge227 on 07/01/2022.
//  Copyright (c) 2022 suoge227. All rights reserved.
//

import UIKit
import suoge_test

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let homeView = HomeView()
        view.addSubview(homeView)
        homeView.frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-64)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

