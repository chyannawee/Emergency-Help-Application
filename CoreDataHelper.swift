//
//  CoreDataHelper.swift
//  War
//
//  Created by Chyanna Wee on 29/04/2018.
//  Copyright © 2018 Chyanna Wee. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct CoreDataHelper {
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }

        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext

        return context
    }()

    static func newNote() -> Note {
        let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note

        return note
    }

    static func saveNote() {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }

    static func delete(note: Note) {
        context.delete(note)

        saveNote()
    }

    static func retrieveNotes() -> [Note] {
        do {
            let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
            let results = try context.fetch(fetchRequest)

            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")

            return []
        }
    }

    static func newContact() -> Contact {
        let contact = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: context) as! Contact

        return contact
    }

    static func saveContact() {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }

    static func delete(contact: Contact) {
        context.delete(contact)

        saveContact()
    }

    static func retrieveContacts() -> [Contact] {
        do {
            let fetchRequest = NSFetchRequest<Contact>(entityName: "Contact")
            let results = try context.fetch(fetchRequest)

            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")

            return []
        }
    }
}
