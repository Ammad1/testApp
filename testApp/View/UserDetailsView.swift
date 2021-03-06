//
//  UserDetailsView.swift
//  testApp
//
//  Created by Ammad Tariq on 03/10/2021.
//

import UIKit

class UserDetailsView: UIView {
    
    //MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var nameValueLabel: UILabel!
    @IBOutlet weak var companyValueLabel: UILabel!
    @IBOutlet weak var blogValueLabel: UILabel!
    @IBOutlet weak var locationValueLabel: UILabel!
    @IBOutlet weak var emailValueLabel: UILabel!
    @IBOutlet weak var hireableValueLabel: UILabel!
    @IBOutlet weak var bioValueLabel: UILabel!
    @IBOutlet weak var twitterValueLabel: UILabel!
    @IBOutlet weak var publicRepoValueLabel: UILabel!
    @IBOutlet weak var publicGistsValueLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    //MARK: Override Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }
    
    //MARK: Helper Methods
    private func setupViews() {
        setData(nil)
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 10
        
        stackView.layer.borderWidth = 1.0
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.cornerRadius = 10
        
        userImageView.layer.cornerRadius = 75
        saveButton.setTitle(AppConstants.Message.save, for: .normal)
        saveButton.layer.cornerRadius = 10.0
    }
    
    func setData(_ userDetails: UserDetails?) {
        
        followersLabel.text = String(userDetails?.followers ?? 0)
        followingLabel.text = String(userDetails?.following ?? 0)
        nameValueLabel.text = userDetails?.name ?? AppConstants.Message.unavailable
        companyValueLabel.text = userDetails?.company ?? AppConstants.Message.unavailable
        blogValueLabel.text = userDetails?.blog ?? AppConstants.Message.unavailable
        locationValueLabel.text = userDetails?.location ?? AppConstants.Message.unavailable
        emailValueLabel.text = userDetails?.email ?? AppConstants.Message.unavailable
        hireableValueLabel.text = userDetails?.hireable ?? AppConstants.Message.unavailable
        bioValueLabel.text = userDetails?.bio ?? AppConstants.Message.unavailable
        twitterValueLabel.text = userDetails?.twitterUsername ?? AppConstants.Message.unavailable
        publicRepoValueLabel.text = String(userDetails?.publicRepos ?? 0)
        publicGistsValueLabel.text = String(userDetails?.publicGists ?? 0)
        
    }
    
    func setImage(withUserId id: Int?) {
        guard let userId = id else {
            userImageView.image = .noUserImage
            return
        }
        
        guard let image = ImageCacheManager.shared.loadImageFromDiskWith(fileName: String(userId)) else {
            self.userImageView.image = .noUserImage
            return
        }
        
        self.userImageView.image = image
        
    }
    
    func setNotesData(_ data: String) {
        disableSaveButton(isSameText: true)
        if data == "" {
            textView.textColor = .placeholderText
            textView.text = AppConstants.Message.addNotesPlaceholder
        } else {
            textView.textColor = .label
            textView.text = data
        }
    }
    
    func disableSaveButton(isSameText: Bool) {
        saveButton.alpha = isSameText ? 0.5 : 1.0
        saveButton.isUserInteractionEnabled = !isSameText
    }
}
