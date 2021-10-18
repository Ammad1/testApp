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
    var previousNotes = ""
    private(set) var userDetails: UserDetails?
    
    //MARK: - Helper Methods
    func fetchUserData(success: @escaping () -> Void,
                       failure: @escaping (_ code: Int?, _ message: String?) -> ()) {
        
        guard let username = username,
              let url = URL(string: AppConstants.Url.users + "/" + username) else {
            
            failure(nil, "Invalid user or URL")
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
            
            guard let data = data, let userDetails = try? JSONDecoder().decode(UserDetails.self, from: data) else {
                failure(nil, "unable to parse data")
                return
            }
            self.userDetails = userDetails
            success()
        })
        task.resume()
    }
}
