//
//  MainControllerViewModel.swift
//  testApp
//
//  Created by Ammad Tariq on 03/10/2021.
//

import Foundation

class MainControllerViewModel {
    
    //MARK: - Properties
    //Comment: Two variables used, user contains all the data fetched till now and filtered contains the filter/unfilter data. Data is filtered and un filtered from this users array. When searching is done and someone want to get out of search, instead of hitting the API we can just simply use the fetched users in the users array. Users array only appends new data.
    private var users = [User]() {
        didSet {
            if users.count == 0 {
                CoreDataManager.shared.deleteAllUserData()
            }
        }
    }
    private(set)var filteredUsers = [User]()
    
    //MARK: - Helper Methods
    func resetData() {
        users = []
        filteredUsers = []
    }
    
    func searchUsers(withKeyword keyword: String, completion: () ->()) {
        filteredUsers = []
        if keyword == "" {
            filteredUsers = users
        } else {
            
            filteredUsers = users.filter({$0.login?.range(of: keyword, options: .caseInsensitive) != nil})
        }
        completion()
    }
    
    func fetchUsers( completion: @escaping (Result<Bool, CustomError>) -> Void) {
                    
        let lastUserId = users.last?.id ?? 0
        guard let url = URL(string: AppConstants.Url.users + "?since=\(lastUserId)&per_page=10") else {
            
            completion(.failure(CustomError(code: nil, message: "invalid URL")))
            return
        }
       
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if let error = error {
                completion(.failure(CustomError(code: nil, message: "Error: \(error.localizedDescription)")))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      
                      completion(.failure(CustomError(code: nil, message: "Error with the response, unexpected status code: \(response?.description ?? "")")))
                      return
                  }
            
            guard let data = data, let users = try? JSONDecoder().decode([User].self, from: data) else {
                completion(.failure(CustomError(code: nil, message: "Unable to parse data")))
                return
            }
            self.users.append(contentsOf: users)
            self.filteredUsers.append(contentsOf: users)
            CoreDataManager.shared.saveUsers(users)
            let isPaginationCompleted = (users.count == 0)
            completion(.success(isPaginationCompleted))
        })
        task.resume()
    }
    
    func loadOfflineData(completion: (()->())? = nil) {
        CoreDataManager.shared.retrieveAllUsers { offlineUsers in
            self.users = offlineUsers
            self.filteredUsers = offlineUsers
            completion?()
        }
    }
}
