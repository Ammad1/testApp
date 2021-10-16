//
//  UserListTableViewCell.swift
//  testApp
//
//  Created by Ammad Tariq on 02/10/2021.
//

import UIKit

class UserListTableViewCell: UITableViewCell {

    private let cache = NSCache<NSNumber, UIImage>()
    var userImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    var dataOuterView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
    var noteIcon = UIImageView()
    var usernameLabel = UILabel()
    var stackView = UIStackView()
    
    func configure(id: Int?) {
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
        userImageView.image = nil
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

        ])
    }
    
    func setData(_ user: User1, isInvertedImage: Bool) {
        usernameLabel.text = user.login ?? AppConstants.Message.unavailable
        noteIcon.isHidden = user.notes.isEmpty
        
        if let id = user.id, var cacheImage = self.cache.object(forKey: NSNumber(value: id)),
           cacheImage != UIImage.noUserImage {

            if isInvertedImage {
                cacheImage = cacheImage.inverseImage()
            }
            self.userImageView.image = cacheImage

        } else {
            if let url = URL(string: user.avatar_url ?? "") {
                DispatchQueue.global().async {
                    var image: UIImage!
                    if let data = try? Data(contentsOf: url) {
                        image = UIImage(data: data)
                    } else {
                        image = .noUserImage
                    }
                    DispatchQueue.main.async {
                        if let id = user.id {
                            self.cache.setObject(image, forKey: NSNumber(value: id))
                        }
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
}
