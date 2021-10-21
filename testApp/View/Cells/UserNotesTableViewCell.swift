//
//  UserNotesTableViewCell.swift
//  testApp
//
//  Created by Ammad Tariq on 21/10/2021.
//

import UIKit

protocol UserNoteCellDelegate {
    func setData(user: User)
}

class UserNotesTableViewCell: BaseTableViewCell {

    //MARK: - Properties
    var noteIcon = UIImageView()
    var usernameLabel = UILabel()
    var stackView = UIStackView()
    
    //MARK: Helper Methods
    override func configure(id: Int?) {
        super.configure(id: id)
        
        usernameLabel.text = ""
        noteIcon.image = .noteIcon
        noteIcon.tintColor = .gray
        noteIcon.isHidden = true
        
        stackView.axis = .horizontal
        stackView.addArrangedSubview(usernameLabel)
        stackView.addArrangedSubview(noteIcon)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        dataOuterView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
    
            stackView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: dataOuterView.trailingAnchor, constant: -10),
            stackView.centerYAnchor.constraint(equalTo: dataOuterView.centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 21),
            
            noteIcon.heightAnchor.constraint(equalToConstant: 20),
            noteIcon.widthAnchor.constraint(equalToConstant: 20),
            
        ])
    }

}

extension UserNotesTableViewCell: UserNoteCellDelegate {
    
    func setData(user: User) {
        usernameLabel.text = user.login ?? AppConstants.Message.unavailable
        CoreDataManager.shared.retrieveNotes(forId: user.id, completion: { notes in
            self.noteIcon.isHidden = notes.isEmpty
        })
        
        setImageData(forUser: user)
    }
}
