//
//  ListContactsTableViewController.swift
//  Contact
//
//  Created by Chyanna Wee on 29/04/2018.
//  Copyright © 2018 Chyanna Wee. All rights reserved.
//

import UIKit
import MessageUI
import CoreLocation

class ListContactsTableViewController: UITableViewController, CLLocationManagerDelegate {

    // MARK: - Properties

    var contacts = [Contact]() {
        didSet {
            tableView.reloadData()
        }
    }

    //locate
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        contacts = CoreDataHelper.retrieveContacts()
        //locate
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    struct GlobalVariable{

        static var setNumber = String("default")
        static var setMessage = String("default")
        static var location = String ("No location")
        static var locality = String ("No locality")
        static var administrativeArea = String ("No administrative area")
        static var thoroughfare = String ("No thoroughfare")
        static var postalCode = String ("No Postal Code")
        static var country = String ("No country")
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listContactsTableViewCell", for: indexPath) as! ListContactsTableViewCell

        let contact = contacts[indexPath.row]
        cell.noteTitleLabel.text = contact.title
        cell.noteModificationTimeStamp.text = contact.modificationTime?.convertToString() ?? "unknown"

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }

        switch identifier {
        case "displayContact":
            guard let indexPath = tableView.indexPathForSelectedRow else { return }

            let contact = contacts[indexPath.row]

            let destination = segue.destination as! DisplayContactViewController

            destination.contact = contact

        case "addContact":
            print("create note bar button item tapped")

        default:
            print("unexpected segue identifier")
        }
    }

    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
        contacts = CoreDataHelper.retrieveContacts()
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexpath) in
            print("Delete Action Tapped")
            let contactToDelete = self.contacts[indexPath.row]
            CoreDataHelper.delete(contact: contactToDelete)

            self.contacts = CoreDataHelper.retrieveContacts()
        }

        let setAction = UITableViewRowAction(style: .destructive, title: "Set") { (action, indexpath) in
            print("Set Action Tapped")

            let contactSet = self.contacts[indexPath.row]
            print (contactSet)
            let fullMessage = contactSet.content!
            let userLocation = ListContactsTableViewController.GlobalVariable.location
            let locality = ListContactsTableViewController.GlobalVariable.locality
            let administrativeArea = ListContactsTableViewController.GlobalVariable.administrativeArea
            let thoroughfare = ListContactsTableViewController.GlobalVariable.thoroughfare
            let postalCode = ListContactsTableViewController.GlobalVariable.postalCode
            let country = ListContactsTableViewController.GlobalVariable.country
            let address = ("This is the address: ")
            let space = (" ")
            ListContactsTableViewController.GlobalVariable.setMessage = (fullMessage +  userLocation + space + address + thoroughfare + space + postalCode + space + locality + space + administrativeArea + space + country)
            ListContactsTableViewController.GlobalVariable.setNumber = contactSet.number!
        }

        deleteAction.backgroundColor = .red
        setAction.backgroundColor = .blue
        return [deleteAction, setAction]
    }

    //locate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let location = locations[0]
        ListContactsTableViewController.GlobalVariable.location = String(describing: location.coordinate)

        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemark, error) in
            if error != nil {
                print("reverse geocoding error")
            }
            else
            {
                if let place = placemark?[0]
                {

                    ListContactsTableViewController.GlobalVariable.locality = String(describing: place.locality ?? "")
                    ListContactsTableViewController.GlobalVariable.administrativeArea = String(describing: place.administrativeArea ?? "")
                    ListContactsTableViewController.GlobalVariable.thoroughfare = String(describing: place.thoroughfare ?? "")
                    ListContactsTableViewController.GlobalVariable.postalCode = String(describing: place.postalCode ?? "")
                    ListContactsTableViewController.GlobalVariable.country = String(describing: place.country ?? "")

                    /*
                    print("0")
                    //klang
                    print(place.locality as Any)
                    print("1")
                    //selangor
                    print(place.administrativeArea as Any)
                    print("2")
                    //jalan selar
                    print(place.thoroughfare as Any)
                    print("3")
                    //41100
                    print(place.postalCode as Any)
                    print("4")
                    //malaysia
                    print(place.country as Any)
                    */


                }
            }
        }

    }
}
