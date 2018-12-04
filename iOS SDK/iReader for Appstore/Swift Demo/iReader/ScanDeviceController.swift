//
//  ScanDeviceController.swift
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

import UIKit

public var readerName: String = ""
public var gContxtHandle: SCARDCONTEXT = 0
let readerInterface = ReaderInterface()

class ScanDeviceController: UITableViewController , ReaderInterfaceDelegate{
    
    lazy var deviceList = [String]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
 
        let rightBtn = UIButton(type: .custom)
        rightBtn.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        rightBtn.setTitle("refresh", for: .normal)
        rightBtn.addTarget(self, action: #selector(scanDevice), for: .touchUpInside)
        rightBtn.setTitleColor(UIColor.black, for: .normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        
    }
    
    override func viewDidLoad() {
        
        readerInterface.setDelegate(self)
        
        let ret = SCardEstablishContext(DWORD(SCARD_SCOPE_SYSTEM), nil, nil, &gContxtHandle)
        if ret != SCARD_S_SUCCESS {
            Tools.shareInstance.showError(errorCode: ret)
        }
    }
    
    @objc func scanDevice() {
       
        self.deviceList.removeAll()
        self.tableView.reloadData()
        
        var ret: LONG = 0
        Tools.shareInstance.showMsg(msg: "scaning devices...")
        
        DispatchQueue.global().async {
            var readerNameLength: DWORD = 0
            ret = SCardListReaders(gContxtHandle, nil, nil, &readerNameLength)
            if ret != 0 {
                Tools.shareInstance.showError(errorCode: ret)
                return
            }
            
            if(readerNameLength == 0) {
                Tools.shareInstance.showMsg(msg: "not find reader")
                return
            }
            
            let mszReaders = UnsafeMutablePointer<CChar>.allocate(capacity: Int(readerNameLength))
            ret = SCardListReaders(gContxtHandle, nil, mszReaders, &readerNameLength)
            if ret != 0 {
                Tools.shareInstance.showError(errorCode: ret)
                return
            }
            
            var tempIndex: Int = 0
            let tempReaderName = UnsafeMutablePointer<CChar>.allocate(capacity: 30)
            for index in 0..<readerNameLength {
                if mszReaders[Int(index)] != 0 {
                    tempReaderName[tempIndex] = mszReaders[Int(index)]
                    tempIndex += 1
                    continue
                }
                
                let deviceName: String = String(cString: tempReaderName)
                
                if !self.deviceList.contains(deviceName) {
                    self.deviceList.append(deviceName)
                }
                memset(tempReaderName, 0, tempIndex)
                tempIndex = 0
            }
            
            mszReaders.deallocate(capacity: Int(readerNameLength))
            tempReaderName.deallocate(capacity: 30)
            
            Tools.shareInstance.hideMsg()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scanDeviceCell")
        cell?.textLabel?.text = deviceList[indexPath.row]
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        readerName = deviceList[indexPath.row]
        performSegue(withIdentifier: "sendAPDU", sender: nil)
    }
}


//MARK:ReaderInterfaceDelegate
extension ScanDeviceController {
    
    func findPeripheralReader(_ readerName: String!) {
        
    }
    
    func readerInterfaceDidChange(_ attached: Bool) {
//        if attached == true {
//            print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!reader  did didetach")
//        }
        
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!reader  did didetach")
    }
    
    func cardInterfaceDidDetach(_ attached: Bool) {
//        print("card did didetach")
    }
}
