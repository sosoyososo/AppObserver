//
//  AOFPSStopObserver.swift
//  AppObserver
//
//  Created by karsa on 2018/2/1.
//  Copyright © 2018年 karsa. All rights reserved.
//

import Foundation

public class AOObserver {
    
    // MARK: Private Support
    private let queue                            = DispatchQueue(label: "AOFPSObserver",
                                                                 qos: DispatchQoS.default,
                                                                 attributes: DispatchQueue.Attributes.concurrent,
                                                                 autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit,
                                                                 target: nil)
    private var observer    : CFRunLoopObserver? = nil
    
    
    private var timer               : Timer?        = nil
    private var isExcuting          : Bool          = false
    private var startExcutingDate   : Date?         = nil
    
    
    
    private init() {
        addMainRunloopObserver()
    }
    
    private func timerCallBack() {
        if self.isExcuting == true {
            if let date = self.startExcutingDate {
                let duration = Date().timeIntervalSince(date)
                if self.durationLimit < duration {
                    self.callBack(duration)
                }
            }
        }
    }
    
    private func observerActivityCallBack(activity : CFRunLoopActivity) {
        if activity == CFRunLoopActivity.beforeSources
            || activity == CFRunLoopActivity.beforeTimers {
            if nil == self.startExcutingDate {
                self.startExcutingDate = Date()
            }
            self.isExcuting = true
        } else if activity == CFRunLoopActivity.beforeWaiting {
            self.isExcuting = false
        } else {
            self.startExcutingDate = nil
        }
    }
    
    private func addMainRunloopObserver() {
        var _self = self
        withUnsafeMutablePointer(to: &_self) { (pSelf) -> Void in
            var observerContext = CFRunLoopObserverContext(
                version: 0,
                info: pSelf,
                retain: nil,
                release: nil,
                copyDescription: nil)
            
            withUnsafeMutablePointer(to: &observerContext, { (pObserverContext) -> Void in
                observer = CFRunLoopObserverCreate(
                    kCFAllocatorDefault,
                    CFRunLoopActivity.allActivities.rawValue,
                    true,
                    0,
                    { (observer, activity, info) in
                        AOObserver.share.observerActivityCallBack(activity: activity)
                    },
                    pObserverContext)
                CFRunLoopAddObserver(CFRunLoopGetMain(), observer, CFRunLoopMode.defaultMode)
            })
        }
    }
    
    // MARK: Public API
    public static  let share                                    = AOObserver()
    public var         observeInterval     : TimeInterval       = 0.05
    public var         durationLimit       : TimeInterval       = 1.0/60.0
    public var         callBack            : (TimeInterval)->() = { (duration) in
    }
    
    public func startObserve() {
        if nil == self.timer {
            queue.async {
                self.timer = Timer.init(timeInterval: self.observeInterval, repeats: true, block: { [unowned self] (timer) in
                    self.timerCallBack()
                })
                if let timer = self.timer {
                    RunLoop.current.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
                    RunLoop.current.run()
                }
            }
        }
    }
    
    public func stopObserve() {
        self.timer?.invalidate()
        self.timer = nil
    }
}
