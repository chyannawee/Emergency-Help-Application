//
//  DisplayContactViewController.swift
//  Contact
//
//  Created by Chyanna Wee on 29/04/2018.
//  Copyright © 2018 Chyanna Wee. All rights reserved.
//

import UIKit

class DisplayContactViewController: UIViewController {

    // MARK: - Properties

    var contact: Contact?

    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var titletextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let contact = contact {
            titletextField.text = contact.title
            contentTextView.text = contact.content
            numberTextField.text = contact.number
        } else {
            titletextField.text = ""
            contentTextView.text = "Help Me! I am here: "
            numberTextField.text = ""
        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }

        switch identifier {
        case "save" where contact != nil:
            contact?.title = titletextField.text ?? ""
            contact?.content = contentTextView.text ?? ""
            contact?.number = numberTextField.text ?? ""
            contact?.modificationTime = Date()

            CoreDataHelper.saveContact()

        case "save" where contact == nil:
            let contact = CoreDataHelper.newContact()
            contact.title = titletextField.text ?? ""
            contact.content = contentTextView.text ?? "Help Me! I am here: "
            contact.number = numberTextField.text ?? ""
            contact.modificationTime = Date()

            CoreDataHelper.saveContact()

        case "cancel":
            print("cancel bar button item tapped")

        default:
            print("unexpected segue identifier")
        }
    }
    
}
