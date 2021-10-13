//
//  LoaderViewController.swift
//  testApp
//
//  Created by Ammad Tariq on 03/10/2021.
//

import UIKit

class LoaderViewController: UIViewController {

    @IBOutlet var loaderView: LoaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loaderView.loader.startAnimating()
    }
    
    deinit {
        loaderView.loader.stopAnimating()
    }

}
