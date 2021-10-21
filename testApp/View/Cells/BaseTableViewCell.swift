//
//  BaseTableViewCell.swift
//  testApp
//
//  Created by Ammad Tariq on 21/10/2021.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    //MARK: - Properties
    var userImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    var dataOuterView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
    
    //MARK: Helper Methods
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
        
        dataOuterView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        
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
    
    func setImageData(forUser user: User, shouldInverse: Bool = false) {
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
            
            setImage(image)
            
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
                
                let userImage = image
                
                DispatchQueue.main.async {
                    ImageCacheManager.shared.saveImage(imageName: String(userId), image: userImage)
                    self.setImage(image)
                }
            }
        }
    }
}
