//
//  UserInvertedTableViewCell.swift
//  testApp
//
//  Created by Ammad Tariq on 21/10/2021.
//

import UIKit

protocol UserInvertedCellDelegate {
    func setData(user: User)
}

class UserInvertedTableViewCell: BaseTableViewCell {

    //MARK: - Properties
    var usernameLabel = UILabel()
    
    //MARK: Helper Methods
    override func configure(id: Int?) {
        super.configure(id: id)
        
        usernameLabel.text = ""
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dataOuterView.addSubview(usernameLabel)
        
        NSLayoutConstraint.activate([
            
            usernameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            usernameLabel.trailingAnchor.constraint(equalTo: dataOuterView.trailingAnchor, constant: -10),
            usernameLabel.centerYAnchor.constraint(equalTo: dataOuterView.centerYAnchor),
            usernameLabel.heightAnchor.constraint(equalToConstant: 21),
            
        ])
    }
}

extension UserInvertedTableViewCell: UserInvertedCellDelegate {
    
    func setData(user: User) {
        usernameLabel.text = user.login ?? AppConstants.Message.unavailable
        setImageData(forUser: user, shouldInverse: true)
    }
}
