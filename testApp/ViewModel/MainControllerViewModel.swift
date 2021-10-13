//
//  MainControllerViewModel.swift
//  testApp
//
//  Created by Ammad Tariq on 03/10/2021.
//

import Foundation

class MainControllerViewModel {
    
    var users = [User1]()
    
    func fetchUsers(success: @escaping (_ isPaginationCompleted: Bool) -> Void,
                    failure: @escaping (_ code: Int?, _ message: String?) -> ()) {
        let lastUserId = users.last?.id ?? 0
        guard let url = URL(string: AppConstants.Url.users + "?since=\(lastUserId)&per_page=10") else {
            failure(nil, "invalid URL")
            return
        }
       
//        guard let url = URL(string: AppConstants.Url.users + "?since=\(0)") else {
//            failure(nil, "invalid URL")
//            return
//        }
//        let container: UIView = UIView()
//            container.frame = CGRect(x: 0, y: 0, width: 80, height: 80) // Set X and Y whatever you want
//            container.backgroundColor = UIColor.black.withAlphaComponent(0.2)
//        container.center = self.view.center
//            let activityView = UIActivityIndicatorView(style: .large)
//        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//            activityView.center = container.center
//
//            container.addSubview(activityView)
//            self.view.addSubview(container)
//        activityView.startAnimating()
        
//        let backgroundColor = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        backgroundColor.center = self.view.center
//        backgroundColor.backgroundColor = UIColor.black.withAlphaComponent(0.2)
//        let indicator = UIActivityIndicatorView(style: .large)
////        backgroundColor.addSubview(indicator)
//        indicator.center = self.view.center
//        indicator.color = .gray
//        indicator.hidesWhenStopped = true
//        indicator.isOpaque = true
//        self.view.addSubview(indicator)
//        indicator.startAnimating()
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            //                DispatchQueue.main.async {
            //                    indicator.stopAnimating()
            //                }
            
            if let error = error {
                failure(nil, "Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                failure(nil, "Error with the response, unexpected status code: \(response?.description ?? "")")
                return
            }
            
            guard let data = data, let users = try? JSONDecoder().decode([User1].self, from: data) else {
                failure(nil, "unable to parse data")
                return
            }
            self.users.append(contentsOf: users)
            success((users.count == 0))
        })
        task.resume()
    }
    
    func searchUser(withUsername username: String, success: @escaping (_ isPaginationCompleted: Bool) -> Void,
    failure: @escaping (_ code: Int?, _ message: String?) -> ()) {
        guard !username.isEmpty, let url = URL(string: AppConstants.Url.users + "/search/users?q=\(username)&per_page=10") else {
            failure(nil, "invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if let error = error {
                failure(nil, "Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                failure(nil, "Error with the response, unexpected status code: \(response?.description ?? "")")
                return
            }
            
            guard let data = data, let users = try? JSONDecoder().decode(SearchUsers.self, from: data) else {
                failure(nil, "unable to parse data")
                return
            }
            self.users.append(contentsOf: users.items)
            success((users.items.count == 0))
        })
        task.resume()
    }
    
    func updateUserNotes(forUserId id: Int?, noteData: String) {
        guard let index = users.firstIndex(where: {$0.id == id}) else { return }
        users[index].notes = noteData
    }
}
