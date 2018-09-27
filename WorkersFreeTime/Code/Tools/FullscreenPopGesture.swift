//
//  FullscreenPopGesture.swift
//  WorkersFreeTime
//
//  Created by 栗志 on 2018/9/27.
//  Copyright © 2018年 com.lizhi1026. All rights reserved.
//

import UIKit

fileprivate struct RuntimeKey {
    static let KEY_willAppearInjectBlockContainer
        = UnsafeRawPointer(bitPattern: "KEY_willAppearInjectBlockContainer".hashValue)
    static let KEY_interactivePopDisabled
        = UnsafeRawPointer(bitPattern: "KEY_interactivePopDisabled".hashValue)
    static let KEY_prefersNavigationBarHidden
        = UnsafeRawPointer(bitPattern: "KEY_prefersNavigationBarHidden".hashValue)
    static let KEY_interactivePopMaxAllowedInitialDistanceToLeftEdge
        = UnsafeRawPointer(bitPattern: "KEY_interactivePopMaxAllowedInitialDistanceToLeftEdge".hashValue)
    static let KEY_fullscreenPopGestureRecognizer
        = UnsafeRawPointer(bitPattern: "KEY_fullscreenPopGestureRecognizer".hashValue)
    static let KEY_popGestureRecognizerDelegate
        = UnsafeRawPointer(bitPattern: "KEY_popGestureRecognizerDelegate".hashValue)
    static let KEY_viewControllerBasedNavigationBarAppearanceEnabled
        = UnsafeRawPointer(bitPattern: "KEY_viewControllerBasedNavigationBarAppearanceEnabled".hashValue)
    static let KEY_scrollViewPopGestureRecognizerEnable
        = UnsafeRawPointer(bitPattern: "KEY_scrollViewPopGestureRecognizerEnable".hashValue)
}


open class FullscreenPopGesture{
    open class func configure(){
        UINavigationController.fp_nav_initialize()
        UIViewController.fp_initialize()
    }
}

private class FullscreenPopGestureRecognizerDelegate:NSObject,UIGestureRecognizerDelegate{
    weak var navigationController: UINavigationController?
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let navigationC = self.navigationController else {
            return false
        }
        
        guard navigationC.viewControllers.count > 1 else {
            return false
        }
        
        guard let topViewController = navigationC.viewControllers.last else {
            return false
        }
        
        guard !topViewController.fp_interactivePopDisabled else {
            return false
        }
        
        guard let trasition = navigationC.value(forKey: "_isTransitioning") as? Bool else {
            return false
        }
        
        guard !trasition else {
            return false
        }
        
        guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }
        
        let beginningLocation = panGesture.location(in: panGesture.view)
        let maxAllowedInitialDistance = topViewController.fp_interactivePopMaxAllowedInitialDistanceToLeftEdge
        guard maxAllowedInitialDistance <= 0 || Double(beginningLocation.x) <= maxAllowedInitialDistance else {
            return false
        }
        
        let translation = panGesture.translation(in: panGesture.view)
        guard translation.x > 0 else {
            return false
        }
        
        return true
    }
}

extension UINavigationController {
    private var popGestureRecognizerDelegate:FullscreenPopGestureRecognizerDelegate {
        guard let delegate = objc_getAssociatedObject(self, RuntimeKey.KEY_popGestureRecognizerDelegate!) as? FullscreenPopGestureRecognizerDelegate else {
            let popDelegate = FullscreenPopGestureRecognizerDelegate()
            popDelegate.navigationController = self
            objc_setAssociatedObject(self, RuntimeKey.KEY_popGestureRecognizerDelegate!, popDelegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return popDelegate
        }
        
         return delegate
    }
    
    open class func fp_nav_initialize(){
        DispatchQueue.once(token: "com.UINavigationController.MethodSwizzling", block: {
            let originalMethod = class_getInstanceMethod(self, #selector(pushViewController(_:animated:)))
            let swizzledMethod = class_getInstanceMethod(self, #selector(fp_pushViewController(_:animated:)))
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        })
    }
    
    @objc private func fp_pushViewController(_ viewController: UIViewController, animated: Bool){
        if self.interactivePopGestureRecognizer?.view?.gestureRecognizers?.contains(self.fp_fullscreenPopGestureRecognizer) == false {
            self.interactivePopGestureRecognizer?.view?.addGestureRecognizer(self.fp_fullscreenPopGestureRecognizer)
            
            let internalTargets = self.interactivePopGestureRecognizer?.value(forKey: "targets") as? Array<NSObject>
            let internalTarget = internalTargets?.first?.value(forKey: "target")
            let internalAction = NSSelectorFromString("handleNavigationTransition:")
            if let target = internalTarget {
                self.fp_fullscreenPopGestureRecognizer.delegate = self.popGestureRecognizerDelegate
                self.fp_fullscreenPopGestureRecognizer.addTarget(target, action: internalAction)
                
                // Disable the onboard gesture recognizer.
                self.interactivePopGestureRecognizer?.isEnabled = false
            }
        }
        
        self.setupViewControllerBasedNavigationBarAppearanceIfNeeded(viewController)
        
        self.fp_pushViewController(viewController, animated: animated)
    }
    
    private func setupViewControllerBasedNavigationBarAppearanceIfNeeded(_ appearingViewController: UIViewController){
        if !self.fp_viewControllerBasedNavigationBarAppearanceEnabled {
            return
        }
        
        let blockContainer = ViewControllerWillAppearInjectBlockContainer() { [weak self] (_ viewController: UIViewController, _ animated: Bool) -> Void in
            self?.setNavigationBarHidden(viewController.fp_prefersNavigationBarHidden, animated: animated)
        }
        
        appearingViewController.fp_willAppearInjectBlockContainer = blockContainer
        let disappearingViewController = self.viewControllers.last
        if let vc = disappearingViewController {
            if vc.fp_willAppearInjectBlockContainer == nil {
                vc.fp_willAppearInjectBlockContainer = blockContainer
            }
        }
    }
    
    public var fp_fullscreenPopGestureRecognizer: UIPanGestureRecognizer{
        guard let pan = objc_getAssociatedObject(self, RuntimeKey.KEY_fullscreenPopGestureRecognizer!) as? UIPanGestureRecognizer else {
            let panGesture = UIPanGestureRecognizer()
            panGesture.maximumNumberOfTouches = 1;
            objc_setAssociatedObject(self, RuntimeKey.KEY_fullscreenPopGestureRecognizer!, panGesture, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            return panGesture
        }
        return pan
    }
    
    public var fp_viewControllerBasedNavigationBarAppearanceEnabled: Bool{
        get {
            guard let bools = objc_getAssociatedObject(self, RuntimeKey.KEY_viewControllerBasedNavigationBarAppearanceEnabled!) as? Bool else {
                self.fp_viewControllerBasedNavigationBarAppearanceEnabled = true
                return true
            }
            return bools
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.KEY_viewControllerBasedNavigationBarAppearanceEnabled!, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}


fileprivate typealias ViewControllerWillAppearInjectBlock = (_ viewController: UIViewController, _ animated: Bool) -> Void

fileprivate class ViewControllerWillAppearInjectBlockContainer {
    var block: ViewControllerWillAppearInjectBlock?
    init(_ block: @escaping ViewControllerWillAppearInjectBlock) {
        self.block = block
    }
}

extension UIViewController {
    fileprivate var fp_willAppearInjectBlockContainer: ViewControllerWillAppearInjectBlockContainer? {
        get {
            return objc_getAssociatedObject(self, RuntimeKey.KEY_willAppearInjectBlockContainer!) as? ViewControllerWillAppearInjectBlockContainer
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.KEY_willAppearInjectBlockContainer!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    open class func fp_initialize() {
        
        DispatchQueue.once(token: "com.UIViewController.MethodSwizzling", block: {
            let originalMethod = class_getInstanceMethod(self, #selector(viewWillAppear(_:)))
            let swizzledMethod = class_getInstanceMethod(self, #selector(fp_viewWillAppear(_:)))
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        })
    }
    
    @objc private func fp_viewWillAppear(_ animated: Bool) {
        // Forward to primary implementation.
        self.fp_viewWillAppear(animated)
        
        if let block = self.fp_willAppearInjectBlockContainer?.block {
            block(self, animated)
        }
    }
    
    public var fp_interactivePopDisabled: Bool {
        get {
            guard let bools = objc_getAssociatedObject(self, RuntimeKey.KEY_interactivePopDisabled!) as? Bool else {
                return false
            }
            return bools
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.KEY_interactivePopDisabled!, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    public var fp_prefersNavigationBarHidden: Bool {
        get {
            guard let bools = objc_getAssociatedObject(self, RuntimeKey.KEY_prefersNavigationBarHidden!) as? Bool else {
                return false
            }
            return bools
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.KEY_prefersNavigationBarHidden!, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    public var fp_interactivePopMaxAllowedInitialDistanceToLeftEdge: Double {
        get {
            guard let doubleNum = objc_getAssociatedObject(self, RuntimeKey.KEY_interactivePopMaxAllowedInitialDistanceToLeftEdge!) as? Double else {
                return 0.0
            }
            return doubleNum
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.KEY_interactivePopMaxAllowedInitialDistanceToLeftEdge!, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
}

extension UIScrollView:UIGestureRecognizerDelegate {
    public var fp_scrollViewPopGestureRecognizerEnable: Bool {
        get {
            guard let bools = objc_getAssociatedObject(self, RuntimeKey.KEY_scrollViewPopGestureRecognizerEnable!) as? Bool else {
                return false
            }
            return bools
        }
        set {
            objc_setAssociatedObject(self, RuntimeKey.KEY_scrollViewPopGestureRecognizerEnable!, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.fp_scrollViewPopGestureRecognizerEnable, self.contentOffset.x <= 0, let gestureDelegate = otherGestureRecognizer.delegate {
            if gestureDelegate.isKind(of: FullscreenPopGestureRecognizerDelegate.self) {
                return true
            }
        }
        return false
    }
}

fileprivate extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}
