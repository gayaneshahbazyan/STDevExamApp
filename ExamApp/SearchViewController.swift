//
//  SearchViewController.swift
//  ExamApp
//
//  Created by Gayane Shahbazyan on 12/15/17.
//  Copyright © 2017 Gayane Shahbazyan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    var searchTxtField: UITextField!
    var searchTblView: UITableView!
    var searchTxt = ""
    var availableUrls: [UserURL]!
    var searchResult: [UserURL] = [UserURL]() {
        didSet {
            self.searchTblView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        searchTxtField = UITextField()
        searchTxtField.delegate = self
        searchTxtField.translatesAutoresizingMaskIntoConstraints = false
        searchTxtField.placeholder = "Search URL"
        searchTxtField.borderStyle = .roundedRect
        self.view.addSubview(searchTxtField)
        self.view.addConstraint(NSLayoutConstraint(item: searchTxtField, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 10))
        self.view.addConstraint(NSLayoutConstraint(item: searchTxtField, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -10))
        self.view.addConstraint(NSLayoutConstraint(item: searchTxtField, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 10))
        searchTxtField.addConstraint(NSLayoutConstraint(item: searchTxtField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40))
        
        searchTblView = UITableView()
        searchTblView.delegate = self
        searchTblView.dataSource = self
        searchTblView.translatesAutoresizingMaskIntoConstraints = false
        searchTblView.register(URLTableViewCell.self, forCellReuseIdentifier: "Cell1")
        self.view.addSubview(searchTblView)
        
        self.view.addConstraint(NSLayoutConstraint(item: searchTblView, attribute: .top, relatedBy: .equal, toItem: searchTxtField, attribute: .bottom, multiplier: 1.0, constant: 10))
        self.view.addConstraint(NSLayoutConstraint(item: searchTblView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: searchTblView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: searchTblView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0))
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchResult = availableUrls.filter({(str:UserURL) -> Bool in
            let stringMatch = str.urlString.containsIgnoringCase(find: textField.text!)
            return stringMatch
        })
        textField.resignFirstResponder()
        searchTblView.reloadData()
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! URLTableViewCell
        
        if !cell.isConstrated {
            cell.constrateCell()
        }
        cell.urlLabel.text = searchResult[indexPath.row].urlString
        cell.urlStatusImgView.isHidden = false
        cell.urlStatusImgView.frame = CGRect(x: self.view.frame.width - 50, y: 0, width: 40, height: 40)

        switch searchResult[indexPath.row].status {
        case 404:
            cell.urlStatusImgView.image = UIImage(named:"notSuccess")
            cell.activityIndicator.stopAnimating()
        case 200:
            cell.urlStatusImgView.image = UIImage(named:"success")
            cell.activityIndicator.stopAnimating()
        default:
            cell.urlStatusImgView.isHidden = true
            cell.activityIndicator.startAnimating()
        }
        return cell
    }
}

extension String {
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
