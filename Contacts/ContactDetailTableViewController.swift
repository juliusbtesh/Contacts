//
//  ContactDetailTableViewController.swift
//  Contacts
//
//  Created by Julius Btesh on 5/13/19.
//  Copyright © 2019 Julius Btesh. All rights reserved.
//

import UIKit
import Kingfisher

class ContactDetailTableViewController: UITableViewController {
    
    private var favoritesButton : UIBarButtonItem?
    
    public var contact: Contact? {
        didSet {
            tableView.reloadData()
            setFavoriteStatus()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritesButton = UIBarButtonItem(image: UIImage(named: Constants.Images.FavoriteFalse), style: .plain, target: self, action: #selector(ContactDetailTableViewController.addToFavorites))
        favoritesButton?.isEnabled = false
        self.navigationItem.rightBarButtonItem = favoritesButton
    }
    
    func setFavoriteStatus() {
        let filled = self.contact?.isFavorite ?? false
        if filled {
            favoritesButton?.image = UIImage(named: Constants.Images.FavoriteTrue)
        } else {
            favoritesButton?.image = UIImage(named: Constants.Images.FavoriteFalse)
        }
        favoritesButton?.isEnabled = true
    }
    
    @objc func addToFavorites() {
        guard let isFavorite = self.contact?.isFavorite else {
            return
        }
        self.contact?.isFavorite = !isFavorite
        
        if self.contact!.isFavorite! {
            NotificationCenter.default.post(name: .userAddFavorite, object: self.contact)
        } else {
            NotificationCenter.default.post(name: .userRemovedFavorite, object: self.contact)
        }
        
        setFavoriteStatus()
    }

    // MARK: - Table View Cell Setup/Indexes
    
    func indexForHeaderRow() -> Int {
        return 0
    }
    
    func numberOfPhoneRows() -> Int {
        return contact?.phone?.allKeys.count ?? 0
    }
    
    func hasAddress() -> Bool {
        return contact?.address != nil
    }
    
    func indexForAddressRow() -> Int {
        return numberOfPhoneRows() + (hasAddress() ? 1 : 0)
    }
    
    func hasBirthdate() -> Bool {
        return (contact?.birthdate as NSString?)?.length ?? 0 > 0
    }
    
    func indexForBirthdate() -> Int {
        return indexForAddressRow() + (hasBirthdate() ? 1 : 0)
    }
    
    func hasEmailAddress() -> Bool {
        return (contact?.emailAddress as NSString?)?.length ?? 0 > 0
    }
    
    func indexForEmailAddress() -> Int {
        return indexForBirthdate() + (hasEmailAddress() ? 1 : 0)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Count number of rows based on Contact Information
        var count = contact != nil ? 1 : 0
        
        count += numberOfPhoneRows()
        count += hasAddress() ? 1 : 0
        count += hasBirthdate() ? 1 : 0
        count += hasEmailAddress() ? 1 : 0
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == indexForHeaderRow() {
            return contactHeaderCell(indexPath: indexPath)
        } else if indexPath.row > 0 && indexPath.row <= numberOfPhoneRows() {
            return contactPhoneCell(indexPath: indexPath)
        } else if indexPath.row == indexForAddressRow() {
            return contactAddressCell(indexPath: indexPath)
        } else if indexPath.row == indexForBirthdate() {
            return contactBirthdateCell(indexPath: indexPath)
        } else if indexPath.row == indexForEmailAddress() {
            return contactEmailCell(indexPath: indexPath)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)

        // Should never reach here

        return cell
    }
 
    func contactHeaderCell(indexPath: IndexPath) -> HeaderTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! HeaderTableViewCell
        
        let processor = DownsamplingImageProcessor(size: cell.contactImageView.frame.size)
        cell.contactImageView.kf.indicatorType = .activity
        cell.contactImageView.layer.cornerRadius = cell.contactImageView.frame.size.width/2
        cell.contactImageView.kf.setImage(
            with: URL(string: contact?.smallImageURL ?? ""),
            placeholder: UIImage(named: Constants.Images.DefaultUserImageLarge),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
        
        cell.nameLabel.text = contact?.name
        cell.companyNameLabel.text = contact?.companyName
        
        return cell
    }
    
    func contactPhoneCell(indexPath: IndexPath) -> InfoTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! InfoTableViewCell
        
        cell.titleLabel.text = "PHONE:"
        
        let phoneNumber = (contact?.phone?.allValues[indexPath.row-1] as! String)
        
        cell.textLabel?.text = phoneNumber.formattedPhoneNumber()
        cell.detailTextLabel?.text = (contact?.phone?.allKeys[indexPath.row-1] as! NSString).capitalized
        
        return cell
    }
    
    func contactAddressCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicInfoCell", for: indexPath)
        
        cell.textLabel?.text = "ADDRESS:"
        cell.detailTextLabel?.text = contact?.fullAddress()
        
        return cell
    }
    
    func contactBirthdateCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicInfoCell", for: indexPath)
        
        cell.textLabel?.text = "BIRTHDATE:"
        cell.detailTextLabel?.text = (contact?.birthdate?.date(format: "yyyy-MM-dd") ?? Date()).asBirthday()
        
        return cell
    }
    
    func contactEmailCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicInfoCell", for: indexPath)
        
        cell.textLabel?.text = "EMAIL:"
        cell.detailTextLabel?.text = contact?.emailAddress
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.row) {
        case 0:
            return CGFloat(Constants.Sizes.DetailHeaderHeight)
        default:
            return CGFloat(Constants.Sizes.DetailCellHeight)
        }
    }
}
