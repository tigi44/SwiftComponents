//
//  UIApplicationExtension.swift
//  SwiftComponents
//
//  Created by tigi KIM on 1/16/26.
//

import UIKit

extension UIApplication {
    public func topViewController(
        base: UIViewController? = nil
    ) -> UIViewController? {
        
        let baseVC: UIViewController?
        
        if let base = base {
            baseVC = base
        } else {
            baseVC = connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }?
                .rootViewController
        }
        
        if let nav = baseVC as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = baseVC as? UITabBarController {
            return topViewController(base: tab.selectedViewController)
        }
        
        if let presented = baseVC?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return baseVC
    }
}
