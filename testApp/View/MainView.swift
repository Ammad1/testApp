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
    let searchTextField = UITextField()
    let searchIconImage = UIImageView()
    let searchOuterView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
    let headerView = UIView()
    let tableView = UITableView()
    let noDataView = UIView()
    let noDataLabel = UILabel()
    
    func initiateView() {
        
        noDataLabel.textColor = .label
        noDataLabel.textAlignment = .center
        noDataLabel.text = "No Data Available"
        noDataLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        noDataView.backgroundColor = .systemBackground
        noDataView.isHidden = true
        tableView.isHidden = true
        
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        searchTextField.borderStyle = .none
        searchTextField.backgroundColor = .systemBackground
        searchTextField.text = ""
        searchTextField.placeholder = AppConstants.Message.searchUsernamePlaceholder
        
        searchIconImage.contentMode = .scaleAspectFit
        searchIconImage.tintColor = .gray
        searchIconImage.image = .searchIcon
        
        searchOuterView.layer.borderColor = UIColor.lightGray.cgColor
        searchOuterView.layer.borderWidth = 1.0
        searchOuterView.layer.cornerRadius = searchOuterView.frame.height / 2.0
        searchOuterView.clipsToBounds = true
       
        headerView.backgroundColor = .systemBackground
        
        tableView.contentInset.bottom = 20.0
        tableView.tableFooterView = UIView()
        tableView.clipsToBounds = true
        
        searchOuterView.addSubview(searchIconImage)
        searchOuterView.addSubview(searchTextField)
        headerView.addSubview(searchOuterView)
        
        searchOuterView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchIconImage.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        noDataView.translatesAutoresizingMaskIntoConstraints = false
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = .systemBackground
        self.addSubview(headerView)
        noDataView.addSubview(noDataLabel)
        self.addSubview(noDataView)
        self.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            headerView.heightAnchor.constraint(equalToConstant: 65),
            
            searchOuterView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20),
            searchOuterView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
            searchOuterView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10),
            searchOuterView.heightAnchor.constraint(equalToConstant: 40),
            
            searchIconImage.bottomAnchor.constraint(equalTo: searchOuterView.bottomAnchor, constant: 0),
            searchIconImage.leadingAnchor.constraint(equalTo: searchOuterView.leadingAnchor, constant: 10),
            searchIconImage.topAnchor.constraint(equalTo: searchOuterView.topAnchor, constant: 0),
            searchIconImage.heightAnchor.constraint(equalToConstant: 20),
            searchIconImage.widthAnchor.constraint(equalToConstant: 20),
            
            searchTextField.bottomAnchor.constraint(equalTo: searchOuterView.bottomAnchor, constant: 0),
            searchTextField.leadingAnchor.constraint(equalTo: searchIconImage.trailingAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: searchOuterView.trailingAnchor, constant: 0),
            searchTextField.topAnchor.constraint(equalTo: searchOuterView.topAnchor, constant: 0),
            searchTextField.heightAnchor.constraint(equalToConstant: 35),
            
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 15),
            
            noDataView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            noDataView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            noDataView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            noDataView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 15),
            
            noDataLabel.leadingAnchor.constraint(equalTo: noDataView.leadingAnchor, constant: 10),
            noDataLabel.trailingAnchor.constraint(equalTo: noDataView.trailingAnchor, constant: -10),
            noDataLabel.heightAnchor.constraint(equalToConstant: 25),
            noDataLabel.centerYAnchor.constraint(equalTo: noDataView.centerYAnchor),
           
        ])
        
    }
    
    func updateViews(isDataAvailable isAvailable: Bool) {
        noDataView.isHidden = isAvailable
        tableView.isHidden = !isAvailable
    }
}
