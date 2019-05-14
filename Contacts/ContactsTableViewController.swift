//
//  ContactsTableViewController.swift
//  Contacts
//
//  Created by Julius Btesh on 5/13/19.
//  Copyright © 2019 Julius Btesh. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {
    
    private var allOtherContacts: NSMutableArray?
    private var allFavoriteContacts: NSMutableArray?
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .userAddFavorite, object: nil)
        NotificationCenter.default.removeObserver(self, name: .userRemovedFavorite, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onFavoritesAdded(_:)), name: .userAddFavorite, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onFavoritesRemoved(_:)), name: .userRemovedFavorite, object: nil)
        
        loadContacts()
    }
    
    @objc func onFavoritesAdded(_ notification:Notification) {
        // Do something now
        let contact = notification.object as! Contact
        
        allOtherContacts?.remove(contact)
        allFavoriteContacts?.add(contact)
        
        reloadLists()
    }
    
    @objc func onFavoritesRemoved(_ notification:Notification) {
        // Do something now
        let contact = notification.object as! Contact
        
        allFavoriteContacts?.remove(contact)
        allOtherContacts?.add(contact)
        
        reloadLists()
    }
    
    func sortLists() {
        self.allOtherContacts?.sort {
            let contactA = $0 as! Contact
            let contactB = $1 as! Contact
            return contactA.name!.compare(contactB.name!)
        }
        self.allFavoriteContacts?.sort {
            let contactA = $0 as! Contact
            let contactB = $1 as! Contact
            return contactA.name!.compare(contactB.name!)
        }
    }
    
    func reloadLists() {
        sortLists()
        tableView.reloadData()
    }
    
    func loadContacts() {
        APIManger.shared.fetchContacts { (contacts) in
            let tempContacts = NSMutableArray()
            let tempFavoriteContacts = NSMutableArray()
            for contactDictionary in contacts ?? NSArray() {
                let contact = Contact(contactInformation: contactDictionary as? NSDictionary ?? NSDictionary())
                if contact.isFavorite ?? false {
                    tempFavoriteContacts.add(contact)
                } else {
                    tempContacts.add(contact)
                }
            }
            
            self.allOtherContacts = NSMutableArray(array: tempContacts)
            self.allFavoriteContacts = NSMutableArray(array: tempFavoriteContacts)
            
            self.reloadLists()
        }
    }
    
    func contactForIndex(indexPath: IndexPath) -> Contact? {
        let row = indexPath.row
        switch (indexPath.section) {
        case 0:
            if row >= self.allFavoriteContacts?.count ?? 0 {
                return nil
            }
            return self.allFavoriteContacts?.object(at: indexPath.row) as? Contact
        case 1:
            if row >= self.allOtherContacts?.count ?? 0 {
                return nil
            }
            return self.allOtherContacts?.object(at: indexPath.row) as? Contact
        default:
            return nil
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return self.allFavoriteContacts?.count ?? 0
        case 1:
            return self.allOtherContacts?.count ?? 0
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 0:
            return "FAVORITE CONTACTS"
        case 1:
            return "OTHER CONTACTS"
        default:
            return "CONTACTS"
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as? ContactTableViewCell

        let contact = contactForIndex(indexPath: indexPath)
                
        cell?.contact = contact

        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Constants.Sizes.ContactCellHeight)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let contactDetailViewController: ContactDetailTableViewController = segue.destination as? ContactDetailTableViewController else {
            return
        }
        
        guard let cell = sender as? ContactTableViewCell else {
            return
        }
        
        guard let contact = cell.contact else {
            return
        }
        
        contactDetailViewController.contact = contact
    }

}
