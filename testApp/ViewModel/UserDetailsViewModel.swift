//
//  UserDetailsViewModel.swift
//  testApp
//
//  Created by Ammad Tariq on 03/10/2021.
//

import Foundation

class UserDetailsViewModel {

    //MARK: - Properties
    var username: String?
    var userId: Int?
    var previousNotes = ""
    private(set) var userDetails: UserDetails?
    
    //MARK: - Helper Methods
    func fetchUserData(completion: @escaping (Result<UserDetails, CustomError>) -> Void) {
        
        guard let username = username,
              let url = URL(string: AppConstants.Url.users + "/" + username) else {
            
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
            
            guard let data = data, let userDetails = try? JSONDecoder().decode(UserDetails.self, from: data) else {
                completion(.failure(CustomError(code: nil, message: "Unable to parse data")))
                return
            }
            self.userDetails = userDetails
            completion(.success(userDetails))
        })
        task.resume()
    }
}
