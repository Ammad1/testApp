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
