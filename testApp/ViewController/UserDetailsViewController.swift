//
//  UserDetailsViewController.swift
//  testApp
//
//  Created by Ammad Tariq on 03/10/2021.
//

import UIKit

class UserDetailsViewController: BaseViewController {

    @IBOutlet var userDetailsView: UserDetailsView!
    var delegate: NoteUpdateDelegate?
    var viewModel = UserDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDetailsView.textView.delegate = self
        userDetailsView.setNotesData(viewModel.previousNotes)
        LoaderManager.show(self.view, message: AppConstants.Message.pleaseWait)
        viewModel.fetchUserData {
            DispatchQueue.main.async {
                LoaderManager.hide(self.view)
                self.userDetailsView.setData(self.viewModel.userDetails)
            }
        } failure: { code, message in
            DispatchQueue.main.async {
                LoaderManager.hide(self.view)
                self.showAlert(title: AppConstants.Message.error, message: message ?? AppConstants.Message.somethingWrong)
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = viewModel.username
    }

    @IBAction
    func savePressed(_ sender: UIButton) {
        var notes = userDetailsView.textView.text ?? ""
        if notes == AppConstants.Message.addNotesPlaceholder {
            notes = ""
        }
        var alertMessage = ""
        if userDetailsView.textView.text == "" {
            CoreDataManager.shared.deleteNote(forId: viewModel.userDetails?.id)
            alertMessage = AppConstants.Message.notesDeleted
            
        } else if viewModel.previousNotes == "" {
            CoreDataManager.shared.saveNotes(forId: viewModel.userDetails?.id, notes)
            alertMessage = AppConstants.Message.notesSaved
            
        } else {
            CoreDataManager.shared.updateNote(forId: viewModel.userDetails?.id, notes)
            alertMessage = AppConstants.Message.notesUpdated
        }
        
        viewModel.previousNotes = notes
        delegate?.NotesUpdated()
        self.view.endEditing(true)
        userDetailsView.disableSaveButton(isSameText: true)
        self.showAlert(title: AppConstants.Message.success, message: alertMessage, completion: nil)
    }
}

extension UserDetailsViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = .label
        if textView.text == AppConstants.Message.addNotesPlaceholder {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            textView.textColor = .placeholderText
            textView.text = AppConstants.Message.addNotesPlaceholder
        } else {
            textView.textColor = .label
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        var txtAfterUpdate = ""
        if let textString = textView.text as NSString? {
            txtAfterUpdate = textString.replacingCharacters(in: range, with: text)
        }
        let isSameText = (txtAfterUpdate == viewModel.previousNotes)
        userDetailsView.disableSaveButton(isSameText: isSameText)
        return true
    }
}
