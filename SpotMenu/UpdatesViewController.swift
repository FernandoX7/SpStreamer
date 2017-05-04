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
    
    // Views
    @IBOutlet weak var alertMessage: NSTextField!
    @IBOutlet weak var currentVersion: NSTextField!
    @IBOutlet weak var versionsTable: NSScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
}
