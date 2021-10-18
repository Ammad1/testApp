//
//  MainViewController.swift
//  testApp
//
//  Created by Ammad Tariq on 30/09/2021.
//

import UIKit

protocol NoteUpdateDelegate {
    func NotesUpdated()
}

class MainViewController: BaseViewController {

    var isPaginationCompleted = false
    var isFirstTimeLoaded = false
    var isSearching = false
    var isApiInProgress = false
    var mainView = MainView()
    
    private let viewModel = MainControllerViewModel()
    private let spinner = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        self.view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            mainView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            mainView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            mainView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
        mainView.initiateView()
        
        mainView.tableView.register(UserListTableViewCell.self, forCellReuseIdentifier: AppConstants.Identifier.MainControllerCell)
        mainView.searchTextField.delegate = self
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.reloadData()
        
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: mainView.tableView.bounds.width, height: CGFloat(40))
        
        if isInternetAvailable {
            if isFirstTimeLoaded == false {
                fetchUsers()
            }
        } else {
            viewModel.loadOfflineData()
            mainView.tableView.reloadData()
            mainView.updateViews(isDataAvailable: self.viewModel.filteredUsers.count > 0)
        }
    }

//    func initiateView() {
//        let searchTextField = UITextField()
//        searchTextField.borderStyle = .none
//        searchTextField.backgroundColor = .systemBackground
//        searchTextField.text = ""
//        searchTextField.placeholder = "Type username to search..."
//
//        let searchIconImage = UIImageView()
//        searchIconImage.contentMode = .scaleAspectFit
//        searchIconImage.tintColor = .gray
//        searchIconImage.image = UIImage(systemName: "magnifyingglass")
//
//        let searchOuterView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
//        searchOuterView.layer.borderColor = UIColor.lightGray.cgColor
//        searchOuterView.layer.borderWidth = 1.0
//
//        let headerView = UIView()
//        headerView.backgroundColor = .systemBackground
//
//        searchOuterView.addSubview(searchIconImage)
//        searchOuterView.addSubview(searchTextField)
//        headerView.addSubview(searchOuterView)
//
//        searchOuterView.translatesAutoresizingMaskIntoConstraints = false
//        headerView.translatesAutoresizingMaskIntoConstraints = false
//        searchTextField.translatesAutoresizingMaskIntoConstraints = false
//        searchIconImage.translatesAutoresizingMaskIntoConstraints = false
//        self.view.backgroundColor = .systemBackground
//        self.view.addSubview(headerView)
//
//        NSLayoutConstraint.activate([
//            headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
//            headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
//            headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
//            headerView.heightAnchor.constraint(equalToConstant: 65),
//
//            searchOuterView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10),
//            searchOuterView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
//            searchOuterView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10),
//            searchOuterView.heightAnchor.constraint(equalToConstant: 40),
//
//            searchIconImage.bottomAnchor.constraint(equalTo: searchOuterView.bottomAnchor, constant: 0),
//            searchIconImage.leadingAnchor.constraint(equalTo: searchOuterView.leadingAnchor, constant: 10),
//            searchIconImage.topAnchor.constraint(equalTo: searchOuterView.topAnchor, constant: 0),
//            searchIconImage.heightAnchor.constraint(equalToConstant: 20),
//            searchIconImage.widthAnchor.constraint(equalToConstant: 20),
//
//            searchTextField.bottomAnchor.constraint(equalTo: searchOuterView.bottomAnchor, constant: 0),
//            searchTextField.leadingAnchor.constraint(equalTo: searchIconImage.trailingAnchor, constant: 10),
//            searchTextField.trailingAnchor.constraint(equalTo: searchOuterView.trailingAnchor, constant: 0),
//            searchTextField.topAnchor.constraint(equalTo: searchOuterView.topAnchor, constant: 0),
//            searchTextField.heightAnchor.constraint(equalToConstant: 35),
//
//        ])
//
//        searchOuterView.layer.cornerRadius = searchOuterView.frame.height / 2.0
//        searchOuterView.clipsToBounds = true
//    }
    
    private func fetchUsers(completion: (()->Void)? = nil) {
        guard isApiInProgress == false else { return }
        isApiInProgress = true
        
        if isFirstTimeLoaded == false {
            LoaderManager.show(self.view, message: AppConstants.Message.pleaseWait)
            CoreDataManager.shared.deleteAllData()
            viewModel.resetData()
        }
        viewModel.fetchUsers { result in
            self.isApiInProgress = false
            DispatchQueue.main.async {
                LoaderManager.hide(self.view)
                self.spinner.stopAnimating()
                
                switch result {
                case .success(let isFinished):
                    
                    self.isPaginationCompleted = isFinished
                    self.mainView.tableView.tableFooterView?.isHidden = true
                    
                    self.mainView.tableView.reloadData()
                    self.mainView.updateViews(isDataAvailable: self.viewModel.filteredUsers.count > 0)
                    self.isFirstTimeLoaded = true
                    
                case .failure(let error):
                    
                    self.showAlert(title: AppConstants.Message.error, message: error.errorMessage)
                    
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func internetAvailable() {
        mainView.hideNoInternetView(true)
        if isFirstTimeLoaded == false {
            fetchUsers()
        }
    }

    override func internetUnavailable() {
        mainView.hideNoInternetView(false)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.Identifier.MainControllerCell) as? UserListTableViewCell else {
            return UITableViewCell()
        }
        let user = viewModel.filteredUsers[indexPath.row]
        cell.configure(id: user.id)
        var isInverted = false
        if ((indexPath.row + 1) % 4) == 0 {
            isInverted = true
        }
        cell.setData(user, isInvertedImage: isInverted)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = viewModel.filteredUsers[indexPath.row]
        guard let controller = UIStoryboard.init(name: AppConstants.Identifier.Main, bundle: nil).instantiateViewController(identifier: AppConstants.Identifier.UserDetailsViewController) as? UserDetailsViewController else {
            return
        }
        controller.viewModel.username = user.login
        controller.viewModel.previousNotes = user.notes
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard isInternetAvailable else { return }
        
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            if !isPaginationCompleted, isSearching == false {
                spinner.startAnimating()
                mainView.tableView.tableFooterView = spinner
                mainView.tableView.tableFooterView?.isHidden = false
                fetchUsers()
            } else {
                mainView.tableView.tableFooterView = UIView()
            }
        }
    }
}

extension MainViewController: NoteUpdateDelegate {
    
    func NotesUpdated() {
        DispatchQueue.main.async {
            self.mainView.tableView.reloadData()
        }
    }
}

extension MainViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let searchText = textField.text ?? ""
        isSearching = (searchText != "")
        viewModel.searchUsers(withKeyword: searchText) {
            self.mainView.tableView.reloadData()
            self.mainView.updateViews(isDataAvailable: self.viewModel.filteredUsers.count > 0)
        }
        return true
    }
}
