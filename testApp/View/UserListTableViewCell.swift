//
//  UserListTableViewCell.swift
//  testApp
//
//  Created by Ammad Tariq on 02/10/2021.
//

import UIKit

class UserListTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
//    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dataOuterView: UIView!
    @IBOutlet weak var noteIcon: UIImageView!
    var usernameLabel = UILabel()
    
    func configure() {
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(usernameLabel)
        
        NSLayoutConstraint.activate([
//            usernameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            usernameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20),
            usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        usernameLabel.text = "test"
//        userImageView.layer.cornerRadius = userImageView.frame.height / 2.0
//        userImageView.image = .noUserImage
//        usernameLabel.text = ""
//        dataOuterView.layer.borderColor = UIColor.gray.cgColor
//        dataOuterView.layer.borderWidth = 1.0
//        dataOuterView.layer.cornerRadius = 10
//
//        dataOuterView.layer.shadowColor = UIColor.black.cgColor
//        dataOuterView.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
//        dataOuterView.layer.shadowOpacity = 0.4
//        dataOuterView.layer.shadowRadius = 3.0
    }
    
    func setData(_ user: User1, isInvertedImage: Bool) {
        usernameLabel.text = user.login ?? AppConstants.Message.unavailable
        noteIcon.isHidden = user.notes.isEmpty
        
        if let url = URL(string: user.avatar_url ?? "") {
            DispatchQueue.global().async {
                var image: UIImage!
                if let data = try? Data(contentsOf: url) {
                    image = UIImage(data: data)
                } else {
                    image = .noUserImage
                }
                DispatchQueue.main.async {
                    var updatedImage = image
                    if isInvertedImage {
                        updatedImage = image.inverseImage()
                    }
                    self.userImageView.image = updatedImage
                        
                }
            }
        } else {
            userImageView.image = .noUserImage
        }
    }
}
