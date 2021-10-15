//
//  MainViewController.swift
//  testApp
//
//  Created by Ammad Tariq on 30/09/2021.
//

import UIKit
import CoreData

protocol NoteUpdateDelegate {
    func updateNote(forUserId id: Int?, data: String)
}

class MainViewController: BaseViewController {

    var isPaginationCompleted = false
    
    var mainView = MainView()
    
    private let viewModel = MainControllerViewModel()
    private let spinner = UIActivityIndicatorView(style: .medium)
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        mainView.tableView.reloadData()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
//        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: mainView.tableView.bounds.width, height: CGFloat(40))
////        testCoreData()
//        fetchData()
       fetchUsers(isFirstTime: true)
    }

    func initiateView() {
        let searchTextField = UITextField()
        searchTextField.borderStyle = .none
        searchTextField.backgroundColor = .systemBackground
        searchTextField.text = ""
        searchTextField.placeholder = "Type username to search..."
        
        let searchIconImage = UIImageView()
        searchIconImage.contentMode = .scaleAspectFit
        searchIconImage.tintColor = .gray
        searchIconImage.image = UIImage(systemName: "magnifyingglass")
        
        let searchOuterView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        searchOuterView.layer.borderColor = UIColor.lightGray.cgColor
        searchOuterView.layer.borderWidth = 1.0
        
        let headerView = UIView()
        headerView.backgroundColor = .systemBackground
        
        searchOuterView.addSubview(searchIconImage)
        searchOuterView.addSubview(searchTextField)
        headerView.addSubview(searchOuterView)
        
        searchOuterView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchIconImage.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            headerView.heightAnchor.constraint(equalToConstant: 65),
            
            searchOuterView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10),
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
            
        ])
        
        searchOuterView.layer.cornerRadius = searchOuterView.frame.height / 2.0
        searchOuterView.clipsToBounds = true
    }
//    private func fetchData() {
//        do {
//            try context.fetch(User.fetchRequest())
//        } catch {
//            self.showAlert(message: "Error")
//        }
//    }
    
    private func testCoreData() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let managedContext = appDelegate.container.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: context)!
        let user = NSManagedObject(entity: userEntity, insertInto: context)
        user.setValue(1, forKey: "id")
        user.setValue(true, forKey: "boolValue")
        user.setValue("testOptionalString", forKey: "optionalString")
        user.setValue("testNonOptionalString", forKey: "nonOptionalString")
        
        do {
            try context.save()
            self.showAlert(message: "Success")
        } catch {
            self.showAlert(message: "CoreDataError")
        }
    }
    
    private func fetchUsers(isFirstTime: Bool = false, completion: (()->Void)? = nil) {
        if isFirstTime {
            LoaderManager.show(self.view, message: AppConstants.Message.pleaseWait)
            viewModel.users = []
        }
        viewModel.fetchUsers(success: { isFinished in
            DispatchQueue.main.async {
                LoaderManager.hide(self.view)
                
                self.isPaginationCompleted = isFinished
                self.mainView.tableView.tableFooterView?.isHidden = true
                self.spinner.stopAnimating()
                self.mainView.tableView.reloadData()
                self.mainView.updateViews(isDataAvailable: self.viewModel.users.count > 0)
            }
        }, failure: {(code, message) in
            DispatchQueue.main.async {
                LoaderManager.hide(self.view)
                self.showAlert(title: AppConstants.Message.error, message: message ?? AppConstants.Message.somethingWrong)
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.Identifier.MainControllerCell) as? UserListTableViewCell else {
            return UITableViewCell()
        }
        let user = viewModel.users[indexPath.row]
        cell.configure()
        var isInverted = false
        if ((indexPath.row + 1) % 4) == 0 {
            isInverted = true
        }
        cell.setData(user, isInvertedImage: isInverted)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = viewModel.users[indexPath.row]
        guard let controller = UIStoryboard.init(name: AppConstants.Identifier.Main, bundle: nil).instantiateViewController(identifier: AppConstants.Identifier.UserDetailsViewController) as? UserDetailsViewController else {
            return
        }
        controller.viewModel.username = user.login
        controller.viewModel.notesData = user.notes
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
           // print("this is the last cell")
//            let isScrollable = mainView.tableView.contentSize.height > (mainView.tableView.superview?.frame.height ?? 0.0)
            if !isPaginationCompleted {
                spinner.startAnimating()
                mainView.tableView.tableFooterView = spinner
                mainView.tableView.tableFooterView?.isHidden = false
                fetchUsers()
            } else {
                mainView.tableView.tableFooterView = UIView()
            }
        }
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let height = scrollView.frame.size.height
//        let contentYoffset = scrollView.contentOffset.y
//        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
//        if distanceFromBottom < height {
//            fetchUsers(completion: {
//                let indexPath = IndexPath(row: self.viewModel.users.count - 8, section: 0)
//                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
//            })
//        }
//    }
}

extension MainViewController: NoteUpdateDelegate {
    
    func updateNote(forUserId id: Int?, data: String) {
        viewModel.updateUserNotes(forUserId: id, noteData: data)
        DispatchQueue.main.async {
            self.mainView.tableView.reloadData()
        }
    }
}
