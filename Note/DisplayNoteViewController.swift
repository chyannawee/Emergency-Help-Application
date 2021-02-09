//
//  DisplayNoteViewController.swift
//  War
//
//  Created by Chyanna Wee on 26/04/2018.
//  Copyright © 2018 Chyanna Wee. All rights reserved.
//

import UIKit

class DisplayNoteViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: - Properties
    //may or may not be nil, hence the optional value
    var note: Note?

    @IBOutlet weak var titleTextField: UITextField!

    @IBOutlet weak var contentTextView: UITextView!

    @IBOutlet weak var locationTextField: UITextField!

    @IBOutlet weak var witnessNameTextField: UITextField!

    @IBOutlet weak var witnessContactTextField: UITextField!

    @IBOutlet weak var witnessName1TextField: UITextField!

    @IBOutlet weak var witnessContact1TextField: UITextField!

    @IBOutlet weak var witnessName2TextField: UITextField!

    @IBOutlet weak var witnessContact2TextField: UITextField!
    
    @IBOutlet weak var aftermathTextField: UITextView!

    @IBOutlet weak var chilldrenTextField: UITextField!

    let picker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()

        createDatePicker ()
    }

    func createDatePicker() {

        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        //done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target:nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)

        titleTextField.inputAccessoryView = toolbar
        titleTextField.inputView = picker

        //format picker for date
        picker.datePickerMode = .dateAndTime
    }


    @objc func donePressed () {

        //format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        let dateString = formatter.string (from: picker.date)

        titleTextField.text = "\(dateString)"
        self.view.endEditing(true)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let note = note {

            titleTextField.text = note.title
            contentTextView.text = note.content
            locationTextField.text = note.location
            witnessNameTextField.text = note.witnessName
            witnessContactTextField.text = note.witnessContact
            witnessName1TextField.text = note.witnessName1
            witnessContact1TextField.text = note.witnessContact1
            witnessName2TextField.text = note.witnessName2
            witnessContact2TextField.text = note.witnessContact2
            aftermathTextField.text = note.aftermath
            chilldrenTextField.text = note.children
  
        } else {

            titleTextField.placeholder = "When did the incident happen?"
            contentTextView.text = ""
            aftermathTextField.text = ""
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let identifier = segue.identifier else { return }

        switch identifier {

        case "save" where note != nil:

            note?.title = titleTextField.text ?? ""
            note?.content = contentTextView.text ?? ""
            note?.location = locationTextField.text ?? ""
            note?.witnessName = witnessNameTextField.text ?? ""
            note?.witnessContact = witnessContactTextField.text ?? ""
            note?.witnessName1 = witnessName1TextField.text ?? ""
            note?.witnessContact1 = witnessContact1TextField.text ?? ""
            note?.witnessName2 = witnessName2TextField.text ?? ""
            note?.witnessContact2 = witnessContact2TextField.text ?? ""
            note?.aftermath = aftermathTextField.text ?? ""
            note?.children = chilldrenTextField.text ?? ""
            note?.modificationTime = Date()

            CoreDataHelper.saveNote()


        case "save" where note == nil:
            let note = CoreDataHelper.newNote()
            note.title = titleTextField.text ?? ""
            note.content = contentTextView.text ?? ""
            note.location = locationTextField.text ?? ""
            note.witnessName = witnessNameTextField.text ?? ""
            note.witnessContact = witnessContactTextField.text ?? ""
            note.witnessName1 = witnessName1TextField.text ?? ""
            note.witnessContact1 = witnessContact1TextField.text ?? ""
            note.witnessName2 = witnessName2TextField.text ?? ""
            note.witnessContact2 = witnessContact2TextField.text ?? ""
            note.aftermath = aftermathTextField.text ?? ""
            note.children = chilldrenTextField.text ?? ""
            note.modificationTime = Date()

           CoreDataHelper.saveNote()

        case "cancel":
            print("cancel bar button item tapped")

        default:
            print("unexpected segue identifier")
        }
    }

}

