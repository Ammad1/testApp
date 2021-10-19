//
//  UserDetailsViewController.swift
//  testApp
//
//  Created by Ammad Tariq on 03/10/2021.
//

import UIKit

class UserDetailsViewController: BaseViewController {

    //MARK: - Outlets
    @IBOutlet var userDetailsView: UserDetailsView!
    
    //MARK: - Properties
    var delegate: NoteUpdateDelegate?
    var viewModel = UserDetailsViewModel()
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDetailsView.textView.delegate = self
        
        LoaderManager.show(self.view, message: AppConstants.Message.pleaseWait)
        viewModel.fetchUserData { user in
            DispatchQueue.main.async {
                LoaderManager.hide(self.view)
                self.userDetailsView.setData(self.viewModel.userDetails)
                CoreDataManager.shared.retrieveNotes(forId: user.id) { notes in
                    self.viewModel.previousNotes = notes
                    self.userDetailsView.setNotesData(notes)
                }
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

    //MARK: - Action Methods
    @IBAction
    func savePressed(_ sender: UIButton) {
        var notes = userDetailsView.textView.text ?? ""
        if notes == AppConstants.Message.addNotesPlaceholder {
            notes = ""
        }
        var alertMessage = ""
        //Comment: If notes text view has placeholder it means we want to delete notes
        if userDetailsView.textView.text == AppConstants.Message.addNotesPlaceholder {
            CoreDataManager.shared.deleteNote(forId: viewModel.userDetails?.id) {
                self.delegate?.NotesUpdated()
            }
            alertMessage = AppConstants.Message.notesDeleted
            
        //Comment: If previous notes was empty it means this is a new note
        } else if viewModel.previousNotes == "" {
            CoreDataManager.shared.saveNotes(forId: viewModel.userDetails?.id, notes) {
                self.delegate?.NotesUpdated()
            }
            alertMessage = AppConstants.Message.notesSaved
            
        //Comment: Else case would be if there was some previous note and we are updating it
        } else {
            CoreDataManager.shared.updateNote(forId: viewModel.userDetails?.id, notes) {
                self.delegate?.NotesUpdated()
            }
            alertMessage = AppConstants.Message.notesUpdated
        }
        
        viewModel.previousNotes = notes
        self.view.endEditing(true)
        userDetailsView.disableSaveButton(isSameText: true)
        self.showAlert(title: AppConstants.Message.success, message: alertMessage, completion: nil)
    }
}

//MARK: - UITextViewDelegate Methods
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
