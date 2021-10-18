//
//  LoaderManager.swift
//  testApp
//
//  Created by Ammad Tariq on 03/10/2021.
//

import Foundation
import MBProgressHUD

class LoaderManager {
    
    //MARK: - Helper Methods
    static func show(_ view: UIView, message: String? = nil) {
        let loader = MBProgressHUD.showAdded(to: view, animated: true)
        loader.mode = .indeterminate
        loader.bezelView.backgroundColor = UIColor.black
        if let message = message {
            loader.label.text = message
        }
        loader.contentColor = UIColor.white
    }
    
    static func hide(_ view: UIView) {
        MBProgressHUD.hide(for: view, animated: true)
    }
}
