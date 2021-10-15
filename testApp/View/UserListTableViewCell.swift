//
//  UserListTableViewCell.swift
//  testApp
//
//  Created by Ammad Tariq on 02/10/2021.
//

import UIKit

class UserListTableViewCell: UITableViewCell {

    var userImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//    @IBOutlet weak var usernameLabel: UILabel!
    var dataOuterView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
    var noteIcon = UIImageView()
    var usernameLabel = UILabel()
    var stackView = UIStackView()
    
    func configure() {
        self.selectionStyle = .none
        self.backgroundColor = .systemBackground
        dataOuterView.backgroundColor = .systemBackground
        dataOuterView.layer.borderColor = UIColor.gray.cgColor
        dataOuterView.layer.borderWidth = 1.0
        dataOuterView.layer.cornerRadius = 10
        dataOuterView.layer.shadowColor = UIColor.black.cgColor
        dataOuterView.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        dataOuterView.layer.shadowOpacity = 0.4
        dataOuterView.layer.shadowRadius = 3.0
        
        userImageView.layer.cornerRadius = userImageView.frame.height / 2.0
        userImageView.image = .noUserImage
        userImageView.clipsToBounds = true
        
        usernameLabel.text = ""
        noteIcon.image = .noteIcon
        noteIcon.tintColor = .gray
        noteIcon.isHidden = true
        
        stackView.axis = .horizontal
        stackView.addArrangedSubview(usernameLabel)
        stackView.addArrangedSubview(noteIcon)
        
        dataOuterView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        dataOuterView.addSubview(userImageView)
        dataOuterView.addSubview(stackView)
        self.addSubview(dataOuterView)
        
        NSLayoutConstraint.activate([
            dataOuterView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            dataOuterView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            dataOuterView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            dataOuterView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            
            userImageView.leadingAnchor.constraint(equalTo: dataOuterView.leadingAnchor, constant: 10),
            userImageView.topAnchor.constraint(equalTo: dataOuterView.topAnchor, constant: 10),
            userImageView.bottomAnchor.constraint(equalTo: dataOuterView.bottomAnchor, constant: -10),
            userImageView.heightAnchor.constraint(equalToConstant: 50),
            userImageView.widthAnchor.constraint(equalToConstant: 50),
        
            stackView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: dataOuterView.trailingAnchor, constant: -10),
            stackView.centerYAnchor.constraint(equalTo: dataOuterView.centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 21),
            
            noteIcon.heightAnchor.constraint(equalToConstant: 20),
            noteIcon.widthAnchor.constraint(equalToConstant: 20),
//            usernameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
//            usernameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
//            usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
//            usernameLabel.heightAnchor.constraint(equalToConstant: 20),
//            usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
//        usernameLabel.text = "test"
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
