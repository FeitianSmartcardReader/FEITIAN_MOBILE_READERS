//
//  DeviceInfoTableViewController.swift
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

import UIKit

let cellID = "deviceInfoCell"

class DeviceInfoTableViewController: UITableViewController {

    let sectionTitleArray = ["Firmware Version", "Serial No.", "SDK Version"]
    var deviceInfoArray: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(84, 0, 0, 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getDeviceInfo()
    }
    
    func getDeviceInfo() {
        Tools.shareInstance.showMsg(msg: "getting device info")
        
        DispatchQueue.global().async {
            var ret:LONG = 0
            
            //get firmware revision
            let _ = {
                
                var firmwareRevision: [Int8] = Array(repeating: 32, count: 0)
                var hardwareRevision: [Int8] = Array(repeating: 32, count: 0)
                
                ret = FtGetDevVer(gCardHandle, &firmwareRevision, &hardwareRevision)
                if ret != SCARD_S_SUCCESS {
                    Tools.shareInstance.showError(errorCode: ret)
                    return
                }
                let strFirmware = String(cString: &firmwareRevision)
                self.deviceInfoArray.append(strFirmware)
            }()
            
            //device serial number
            let _ = {
               
                var buffer: [Int8] = Array(repeating: 16, count: 0)
                var length: UInt32 = 0
                
                ret = FtGetSerialNum(gCardHandle, &length, &buffer)
                if ret != SCARD_S_SUCCESS {
                    Tools.shareInstance.showError(errorCode: ret)
                    return
                }
                
                let data = Data(bytes: &buffer, count: Int(length))
                let str = String(format: "%@", data as CVarArg)
                self.deviceInfoArray.append(str)
            }()
            
            //lib version
            let _ = {
                
                var libVersion: [Int8] = Array(repeating: 16, count: 0)
                FtGetLibVersion(&libVersion)
                let strLibVersion = String(cString: &libVersion)
                self.deviceInfoArray.append(strLibVersion)
            }()
            
            Tools.shareInstance.hideMsg()
            
            //update tableview
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension DeviceInfoTableViewController {
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return deviceInfoArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        cell.textLabel?.text = deviceInfoArray[indexPath.section]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionTitleArray[section]
    }
}
