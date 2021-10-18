//
//  BaseViewController.swift
//  testApp
//
//  Created by Ammad Tariq on 30/09/2021.
//

import UIKit
import Network

class BaseViewController: UIViewController {

    // MARK: Instance Variables
    private var currentModalPresentationStyle: UIModalPresentationStyle = .fullScreen
    let monitor = NWPathMonitor()
    
    var isInternetAvailable: Bool {
        return monitor.currentPath.status != .unsatisfied
    }
    
    // MARK: Overrided Properties
    override var modalPresentationStyle: UIModalPresentationStyle {
        get {
            return currentModalPresentationStyle
        }
        set {
            self.currentModalPresentationStyle = newValue
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    deinit {
        monitor.cancel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .unsatisfied {
                    self.internetUnavailable()
                } else {
                    self.internetAvailable()
                }
            }
        }
    }
    
    func internetAvailable() {
        print("Internet Available")
    }
    
    func internetUnavailable() {
        print("Internet Not Available")
    }
    
    func showAlert(title: String = "", message: String, completion: (() -> ())? = nil) {
        DispatchQueue.main.async {
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: {_ in
                completion?()
            })
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @available(iOS 13.0, *)
    override var overrideUserInterfaceStyle: UIUserInterfaceStyle {
        get {
            return .light
        }
        set {
            super.overrideUserInterfaceStyle = newValue
        }
    }
}
