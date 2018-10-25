//
//  RxHelper.swift
//  TheMovieApp
//
//  Created by Luis Cabarique on 10/25/18.
//  Copyright © 2018 cabarique inc. All rights reserved.
//

import Foundation
import RxSwift

extension NSObject {
    
    fileprivate struct AssociatedKeys {
        static var DisposeBagKey = "bnd_DisposeBagKey"
        static var AssociatedObservablesKey = "bnd_AssociatedObservablesKey"
    }
    
    // A dispose bag will will dispose upon object deinit.
    public var disposeBag: DisposeBag {
        get {
            if let disposeBag: AnyObject = objc_getAssociatedObject(self, &AssociatedKeys.DisposeBagKey) as AnyObject? {
                return disposeBag as! DisposeBag
            } else {
                let disposeBag = DisposeBag()
                objc_setAssociatedObject(self, &AssociatedKeys.DisposeBagKey, disposeBag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return disposeBag
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.DisposeBagKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

