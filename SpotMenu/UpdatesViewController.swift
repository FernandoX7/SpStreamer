//
//  UpdatesViewController.swift
//  SpStreamer
//
//  Created by Fernando Ramirez on 5/3/17.
//  Copyright © 2017 Fernando Ramirez. All rights reserved.
//

import Cocoa
import SwiftyJSON
import Alamofire

class UpdatesViewController: NSViewController {
    
    // Vars
    var versionNames = [String]();
    var versionURLS = [String]();
    var universalCell: NSTableCellView? = nil
    
    // Views
    @IBOutlet weak var alertMessage: NSTextField!
    @IBOutlet weak var currentVersion: NSTextField!
    @IBOutlet weak var versionsTableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        versionsTableView.delegate = self
        versionsTableView.dataSource = self
        versionsTableView.target = self
        versionsTableView.doubleAction = #selector(tableViewDoubleClick(_:))
        getAppVersionInfo()
        checkForUpdates()
    }
    
    func checkForUpdates() {
        let url = "https://spstreamer-changelog-server.firebaseio.com/versions.json"
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //                print("JSON: \(json)")
                
                for (_,subJson):(String, JSON) in json {
                    //                    print("[\(key)] --- \(subJson)")
                    let name = String(describing: subJson["name"])
                    let url = String(describing: subJson["url"])
                    self.versionNames.append(name)
                    self.versionURLS.append(url)
                    //                    print("[\(key)] \n Name: \(subJson["name"]) \n URL: \(subJson["url"])")
                }
                print(self.versionNames)
                print(self.versionURLS)
                self.versionsTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
    
    func getAppVersionInfo() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.currentVersion.stringValue = "Version: " + version
        }
    }
    
    func tableViewDoubleClick(_ sender:AnyObject) {
        let textFieldURLValue = universalCell?.textField?.stringValue;
        let projectUrl = URL(string: textFieldURLValue!)
        
        if let url = projectUrl, NSWorkspace.shared().open(url) {
            print("Default browser successfully opened: \(url)")
        }
    }
    
}

extension UpdatesViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return versionNames.count
    }
    
}

extension UpdatesViewController: NSTableViewDelegate {
    
    fileprivate enum CellIdentifiers {
        static let VersionsCell = "VersionCellID"
        static let DownloadCellID = "DownloadCellID"
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text: String = ""
        var cellIdentifier: String = ""
        
        if tableColumn == tableView.tableColumns[0] {
            text = versionNames[row]
            cellIdentifier = CellIdentifiers.VersionsCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = versionURLS[row]
            cellIdentifier = CellIdentifiers.DownloadCellID
        }
        
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            universalCell = cell
            return cell
        }
        
        return nil
    }
    
}

