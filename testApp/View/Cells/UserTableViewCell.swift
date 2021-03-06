//
//  BaseTableViewCell.swift
//  testApp
//
//  Created by Ammad Tariq on 21/10/2021.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    //MARK: - Properties
    var userImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    var dataOuterView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
    var noteIcon = UIImageView()
    var usernameLabel = UILabel()
    var stackView = UIStackView()
    
    //MARK: Helper Methods
    private func configure(id: Int?) {
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
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dataOuterView.addSubview(stackView)
        dataOuterView.addSubview(userImageView)
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
        
        CoreDataManager.shared.isProfileViewed(withUserId: id) { isViewed in
            if isViewed {
                self.dataOuterView.backgroundColor = .lightText
            }
        }
    }

    private func setImage(_ userImage: UIImage, shouldInverse: Bool = false) {
        guard shouldInverse else {
            DispatchQueue.main.async {
                self.userImageView.image = userImage
            }
            return
        }
        
        userImage.inverseImage { inversedImage in
            DispatchQueue.main.async {
                self.userImageView.image = inversedImage
            }
        }
    }
    
    private func setImageData(forUser user: User, shouldInverse: Bool) {
        guard let userId = user.id else {
            userImageView.image = .noUserImage
            return
        }
        //Comment: If image present on disk, load it and check for inverted and proceed accordingly. If not then download the image, store it on disk and use it in our imageview
        if ImageCacheManager.shared.isImageAlreadySaved(imageName: String(userId)) {
            guard let image = ImageCacheManager.shared.loadImageFromDiskWith(fileName: String(userId)) else {
                self.userImageView.image = .noUserImage
                return
            }
            
            setImage(image, shouldInverse: shouldInverse)
            
        } else {
            guard let urlString = user.avatarUrl, let imageUrl = URL(string: urlString) else {
                userImageView.image = .noUserImage
                return
            }
            DispatchQueue.global().async {
                
                guard let data = try? Data(contentsOf: imageUrl), let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        self.userImageView.image = .noUserImage
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    ImageCacheManager.shared.saveImage(imageName: String(userId), image: image)
                    self.setImage(image, shouldInverse: shouldInverse)
                }
            }
        }
    }
    
    func setData(forUser user: User, shouldInverse: Bool = false) {
        configure(id: user.id)
        
        usernameLabel.text = user.login ?? AppConstants.Message.unavailable
        CoreDataManager.shared.retrieveNotes(forId: user.id, completion: { notes in
            self.noteIcon.isHidden = notes.isEmpty
        })
       setImageData(forUser: user, shouldInverse: shouldInverse)
    }
}
