//
//  MainView.swift
//  testApp
//
//  Created by Ammad Tariq on 07/10/2021.
//

import UIKit

class MainView: UIView {

//    @IBOutlet weak var searchOuterView: UIView!
//    @IBOutlet weak var searchTextField: UITextField!
//    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }

    private func setupViews() {
//        tableView.tableFooterView = UIView()
//        searchTextField.text = ""
//        searchOuterView.layer.cornerRadius = searchOuterView.frame.height / 2.0
//        searchOuterView.layer.borderColor = UIColor.lightGray.cgColor
//        searchOuterView.layer.borderWidth = 1.0
//
//        tableView.contentInset.bottom = 20.0
    }
    
    func initiateView() {
        let searchTextField = UITextField()
        searchTextField.borderStyle = .none
        
        let searchIconImage = UIImageView()
        searchIconImage.contentMode = .scaleAspectFit
        searchIconImage.image = UIImage(systemName: "magnifyingglass")
        
        let searchOuterView = UIView()
        let headerView = UIView()
        
        searchOuterView.addSubview(searchIconImage)
        searchOuterView.addSubview(searchTextField)
        headerView.addSubview(searchOuterView)
        
        searchOuterView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchIconImage.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            headerView.heightAnchor.constraint(equalToConstant: 65),
            
            searchOuterView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            searchOuterView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
            searchOuterView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: 10),
            searchOuterView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            
            searchIconImage.bottomAnchor.constraint(equalTo: searchOuterView.bottomAnchor, constant: 0),
            searchIconImage.leadingAnchor.constraint(equalTo: searchOuterView.leadingAnchor, constant: 0),
            searchIconImage.topAnchor.constraint(equalTo: searchOuterView.topAnchor, constant: 0),
            searchIconImage.heightAnchor.constraint(equalToConstant: 35),
            searchIconImage.widthAnchor.constraint(equalToConstant: 35),
            
            searchTextField.bottomAnchor.constraint(equalTo: searchOuterView.bottomAnchor, constant: 0),
            searchTextField.leadingAnchor.constraint(equalTo: searchIconImage.leadingAnchor, constant: 0),
            searchTextField.trailingAnchor.constraint(equalTo: searchOuterView.trailingAnchor, constant: 0),
            searchTextField.topAnchor.constraint(equalTo: searchOuterView.topAnchor, constant: 0),
            
        ])
    }
}
