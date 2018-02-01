//
//  ViewController.swift
//  Demo
//
//  Created by karsa on 2018/2/1.
//  Copyright © 2018年 karsa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.red
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.tapAction(gesture:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func tapAction(gesture : UITapGestureRecognizer) {
        let start = Date()
        for _ in 0..<1500 {
            let tmpView = UIView()
            view.addSubview(tmpView)
            tmpView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            view.layoutSubviews()
            tmpView.removeFromSuperview()
            
        }
        print("exc \(Date().timeIntervalSince(start))")
    }
}

