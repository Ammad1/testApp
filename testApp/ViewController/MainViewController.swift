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

    //MARK: - Properties
    var isPaginationCompleted = false
    var isFirstTimeLoaded = false
    var isSearching = false
    var isApiInProgress = false
    var mainView = MainView()
    
    private let viewModel = MainControllerViewModel()
    private let spinner = UIActivityIndicatorView(style: .medium)
    
    //MARK: - Life Cycle MEthods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
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
        mainView.hideNoInternetView(self.isInternetAvailable)
        
        mainView.tableView.register(UserTableViewCell.self, forCellReuseIdentifier: AppConstants.Identifier.UserTableViewCell)
        mainView.searchTextField.delegate = self
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.reloadData()
        
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: mainView.tableView.bounds.width, height: CGFloat(40))
        
    }

    //MARK: - Helper Methods
    /*Comment:
     isApiInProgress = So that one Api hit at a time
     isFirstTimeLoaded = So as to check if one time data is loaded?
     */
    private func fetchUsers(completion: (()->Void)? = nil) {
        guard isApiInProgress == false else { return }
        isApiInProgress = true
        
        if isFirstTimeLoaded == false {
            viewModel.resetData()
        }
        LoaderManager.show(self.view, message: AppConstants.Message.pleaseWait)
        viewModel.fetchUsers { result in
            self.isApiInProgress = false
            
            DispatchQueue.main.async {
                LoaderManager.hide(self.view)
                self.spinner.stopAnimating()
                
                switch result {
                case .success(let isFinished):
                    self.mainView.tableView.reloadData()
                    if self.isFirstTimeLoaded == false, self.viewModel.filteredUsers.count > 0 {
                        self.mainView.tableView.scrollToRow(at: IndexPath(row: 0,
                                                                          section: 0), at: .top, animated: true)
                    }
                    self.isPaginationCompleted = isFinished
                    self.mainView.tableView.tableFooterView?.isHidden = true
                    
                    self.mainView.updateViews(isDataAvailable: self.viewModel.filteredUsers.count > 0)
                    self.isFirstTimeLoaded = true
                    
                case .failure(let error):
                    
                    self.showAlert(title: AppConstants.Message.error, message: error.errorMessage)
                    
                }
            }
        }
    }
    
    override func internetAvailable() {
        mainView.hideNoInternetView(true)
        fetchUsers()
    }

    override func internetUnavailable() {
        mainView.hideNoInternetView(false)
        
        viewModel.loadOfflineData {
            self.mainView.tableView.reloadData()
            self.mainView.updateViews(isDataAvailable: self.viewModel.filteredUsers.count > 0)
        }
    }
}

//MARK: - UITableView Delegate Methods
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.Identifier.UserTableViewCell) as? UserTableViewCell else {
            
            return UITableViewCell()
        }
        let user = viewModel.filteredUsers[indexPath.row]
        
        let isInverted = (((indexPath.row + 1) % 4) == 0)
        
        cell.setData(forUser: user, shouldInverse: isInverted)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = viewModel.filteredUsers[indexPath.row]
        guard let controller = UIStoryboard.init(name: AppConstants.Identifier.Main, bundle: nil).instantiateViewController(identifier: AppConstants.Identifier.UserDetailsViewController) as? UserDetailsViewController else {
            return
        }
        
        CoreDataManager.shared.profileViewed(withUserId: user.id) {
            self.mainView.tableView.reloadData()
        }
        
        controller.viewModel.username = user.login
        controller.viewModel.userId = user.id
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard isInternetAvailable else { return }
        
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            //Comment: If searching mode on, no need to have pagination. isPaginationCompleted means that no new data is available and all the pages have been loaded
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

//MARK: - NoteUpdateDelegate Extension
extension MainViewController: NoteUpdateDelegate {
    
    func NotesUpdated() {
        DispatchQueue.main.async {
            self.mainView.tableView.reloadData()
        }
    }
}

//MARK: - UITextFieldDelegate Methods
extension MainViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let searchText = textField.text ?? ""
        isSearching = (searchText != "")
        viewModel.searchUsers(withKeyword: searchText) {
            self.mainView.tableView.reloadData()
            self.mainView.updateViews(isDataAvailable: self.viewModel.filteredUsers.count > 0)
        }
        textField.resignFirstResponder()
        return true
    }
}
