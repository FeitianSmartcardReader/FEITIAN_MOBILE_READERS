//
//  SelectReaderTypeController.swift
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

import UIKit

public var gContxtHandle: SCARDCONTEXT = 0

class SelectReaderTypeController: UITableViewController {

    let titleArr = ["iR301 & bR301", "bR301FC4 & bR500"]
    let imageArr = ["iR301bR301", "bR500"]
    let cellID = "readerCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 250
        self.tableView.register(UINib(nibName: String(describing: ReaderTypeTableViewCell.self), bundle: nil), forCellReuseIdentifier: cellID)
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)

    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: ReaderTypeTableViewCell
        
        if let tempCell = tableView.dequeueReusableCell(withIdentifier: cellID) {
            cell = tempCell as! ReaderTypeTableViewCell
        }else {
            cell = ReaderTypeTableViewCell(style: .default, reuseIdentifier: cellID)
        }
        
        cell.readerImage.image = UIImage(named: imageArr[indexPath.row])
        cell.readerLabel.text = titleArr[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            DeviceType.setDeviceType(IR301_AND_BR301)
        }else {
            DeviceType.setDeviceType(BR301BLE_AND_BR500)
        }
        
        let ret = SCardEstablishContext(DWORD(SCARD_SCOPE_SYSTEM), nil, nil, &gContxtHandle)
        if ret != SCARD_S_SUCCESS {
            Tools.shareInstance.showError(errorCode: ret)
        }
        
        performSegue(withIdentifier: "scanDevice", sender: nil)
    }
}

