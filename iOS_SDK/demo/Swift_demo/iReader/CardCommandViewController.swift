//
//  CardCommandViewController.swift
//  iReader
//
//  Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
//

import UIKit

public var gCardHandle: SCARDHANDLE = 0

class CardCommandViewController: UIViewController, CommandViewDelegate  {
    
    @IBOutlet weak var logView: UITextView!
    @IBOutlet weak var apduInputField: UITextField!
    @IBOutlet weak var keyboardView: UIView!
    @IBOutlet weak var commandListBtn: UIButton!
    @IBOutlet weak var keyboardViewBottonConstraint: NSLayoutConstraint!
    @IBOutlet weak var commandListViewTopConstraint: NSLayoutConstraint!
        
    //show flag of commandlist and keyboard
    var _isCommandListViewShow: Bool = false
    var _isKeyboardShow: Bool = false
    
    //commandView and cover
    var commandView: CommandView!
    var coverView: UIView!
    
    //lazy collectionview`s datasource
    let imageArray = ["WriteFlash", "ReadFlash", "UID"]
    let titleArray = ["writeFlash", "readFlash", "readUID"]
    var tempSource = [CommandModel]()
    
    lazy var dataSource: [CommandModel] = {
        var m_WriteFlash = CommandModel(title: titleArray[0], imageName: imageArray[0], action: {
            self.writeFlash()
        })
        
        var m_ReadFlash = CommandModel(title: titleArray[1], imageName: imageArray[1], action: {
            self.readFlash()
        })
        
        var m_ReadUID = CommandModel(title: titleArray[2], imageName: imageArray[2], action: {
            self.readUID()
        })
        
        tempSource.append(m_WriteFlash)
        tempSource.append(m_ReadFlash)
        tempSource.append(m_ReadUID)
        
        return tempSource
    }()
}

//MARK: - button action
extension CardCommandViewController {

    @IBAction func listCommand(_ sender: Any) {
        
        if _isKeyboardShow {
            apduInputField.resignFirstResponder()
        }
        
        if _isCommandListViewShow {
            commandListViewTopConstraint.constant = 0
            keyboardViewBottonConstraint.constant = 0
            
            _isCommandListViewShow = false
            commandListBtn.imageView?.transform = CGAffineTransform(rotationAngle: 0)
        }else {
            commandListViewTopConstraint.constant = CGFloat(-CommandListViewHeight)
            keyboardViewBottonConstraint.constant = CGFloat(CommandListViewHeight)
            
            _isCommandListViewShow = true
            commandListBtn.imageView?.transform = CGAffineTransform(rotationAngle: .pi)
        }
        
        UIView.animate(withDuration: animateDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func sendCommand(_ sender: Any) {

        if let command = self.apduInputField.text {
            if command.count > 5 {
                self.sendTheCommand(command: command)
                return
            }
        }

        Tools.shareInstance.showError(errorInfo: "invalid APUD")
    }
    
    @IBAction func segmentValueChanged(_ sender: Any) {
        let segment: UISegmentedControl = sender as! UISegmentedControl
        
        switch segment.selectedSegmentIndex {
        case 0:
            connectReader()
        case 1:
            disConnectCard()
    
        default: break
        }
    }
}

//MARK: - PSCS function
extension CardCommandViewController {

    func excuteFunc(msg: String, function: @escaping () -> (LONG)) {
        var ret: LONG = 0
        Tools.shareInstance.showMsg(msg: msg)

        DispatchQueue.global().async {

            ret = function()

            Tools.shareInstance.hideMsg()

            if ret != SCARD_S_SUCCESS {
                let errorMsg = String(format: "\(msg) error:%08x", arguments: [ret])
                self.printLog(log: errorMsg)
            }else {
                self.printLog(log: "\(msg) success")
            }
        }
    }
    
    //connect reader
    func connectReader() {
        
        excuteFunc(msg: "connecting reader") { () -> (LONG) in
            var dwActiveProtocol: DWORD  = 0;
            return SCardConnect(gContxtHandle, LPCSTR(readerName.cString(using: .utf8)), DWORD(SCARD_SHARE_SHARED),DWORD(SCARD_PROTOCOL_T0 | SCARD_PROTOCOL_T1), &gCardHandle, &dwActiveProtocol)
        }
    }
    
    //disconnect reader
    func disConnectCard() {
        excuteFunc(msg: "disconnect card") { () -> (LONG) in
            return SCardDisconnect(gCardHandle, DWORD(SCARD_UNPOWER_CARD))
        }
    }
    
    //send command
    func sendTheCommand(command: String) {
        self.printLog(log: "\n")
        
        excuteFunc(msg: "sending command") { () -> (LONG) in

            var capdulen: DWORD = 64
            var capdu: [CUnsignedChar] = Array(repeatElement(0, count: 64))

            var resp: [CUnsignedChar] = Array(repeatElement(0, count: 64))
            var resplen: DWORD = 64

            let apduData = hex.hex(from: command)
            apduData?.copyBytes(to: &capdu, count: (apduData?.count)!)
            capdulen = DWORD(apduData!.count)
            var pioSendPci: SCARD_IO_REQUEST = SCARD_IO_REQUEST()

            self.printLog(log: "send command:\(command)")

            let ret: LONG = SCardTransmit(gCardHandle, &pioSendPci, capdu, capdulen, nil, &resp, &(resplen))

            if ret == SCARD_S_SUCCESS {

                let data = Data(bytes: &resp, count: Int(resplen))
                let str = String(format: "%@", data as CVarArg)
                self.printLog(log: "Rec: \(str)")
            }

            return ret
        }

    }
    
    func writeFlash() {
        closeButtonClickCallback()
        self.printLog(log: "\n")
        
        excuteFunc(msg: "write flash") { () -> (LONG) in
            let filePath = Bundle.main.path(forResource: "flash", ofType: "txt")
            var fileStr = ""

            do {
                fileStr = try String(contentsOf: URL(fileURLWithPath: filePath!), encoding: String.Encoding.utf8)
            }

            catch let error as NSError{
                self.printLog(log: error.domain)
                return -1
            }

            fileStr = fileStr.replacingOccurrences(of: "\r\n", with: " ")
            let fileData = fileStr.data(using: String.Encoding.utf8)

            if let _fileData = fileData {

                if _fileData.count == 0 {
                    self.printLog(log: "flash data is nil")
                    return -1
                }

                let buffer: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer<UInt8>.allocate(capacity: _fileData.count)
                _fileData.copyBytes(to: buffer, count: _fileData.count)

                let ret = FtWriteFlash(gCardHandle, 0, UInt8(_fileData.count), buffer)

                buffer.deinitialize()

                return ret
            }

            self.printLog(log: "flash data is nil")
            return -1
        }
    }
    
    func readFlash() {
        closeButtonClickCallback()
        self.printLog(log: "\n")

        excuteFunc(msg: "read flash") { () -> (LONG) in

            let buffer: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer<UInt8>.allocate(capacity: 256)
            var length: UInt32 = 255

            let ret = FtReadFlash(gCardHandle, 0, &length, buffer)
            if ret != SCARD_S_SUCCESS {
                buffer.deinitialize()
                return ret
            }

            let data = Data(bytes: buffer, count: Int(length))
            let str = String(format: "flash: %@", data as CVarArg)
            self.printLog(log: str)

            buffer.deinitialize()
            return ret
        }
    }
    
    func readUID() {
        closeButtonClickCallback()
        self.printLog(log: "\n")

        excuteFunc(msg: "readUID") { () -> (LONG) in
            var buffer: [Int8] = Array(repeating: 0, count: 20)
            var length: UInt32 = 20
            let ret = FtGetDeviceUID(gCardHandle, &length, &buffer)

            if ret != SCARD_S_SUCCESS {
                return ret
            }

            let data = Data(bytes: &buffer, count: Int(length))
            let str = String(format: "UID: %@", data as CVarArg)
            self.printLog(log: str)

            return ret
        }
    }
}

//MARK: - keyboard/tabbar notification
extension CardCommandViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
        
        disConnectCard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        apduInputField.text = apduArray[0]
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(tabbarMiddleButtonClick), name: NSNotification.Name(rawValue: tabbarMiddleButtonClickNotification), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        addCommandView()
        connectReader()
    }
    
    func addCommandView() {
        
        let commandViewH = CGFloat(300)
        let commandViewW = screenWidth
        let commandViewX = CGFloat(0)
        let commandViewY = screenHeight - commandViewH
        
        let commandViewFrame = CGRect(x: commandViewX, y: commandViewY, width: commandViewW, height: commandViewH)
        commandView = CommandView(frame: commandViewFrame, dataSource: dataSource, delegate: self)
        
        //add cover
        coverView = UIView(frame: UIScreen.main.bounds)
        coverView.backgroundColor = UIColor.black
        coverView.alpha = 0.3
        
        commandView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
        coverView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
        
        self.view.window?.addSubview(coverView)
        self.view.window?.addSubview(commandView)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            _isKeyboardShow = true
            
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let keyboardHeight = frame.height
            
            //animate
            self.keyboardViewBottonConstraint.constant = (keyboardHeight - CGFloat(inputViewHeight))
            
            //hide command list view
            if _isCommandListViewShow {
                commandListViewTopConstraint.constant = 0
                _isCommandListViewShow = false
            }
            
            UIView.animate(withDuration: duration as! TimeInterval, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            _isKeyboardShow = false
            
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]
            
            //animate
            self.keyboardViewBottonConstraint.constant = 0
            
            UIView.animate(withDuration: duration as! TimeInterval, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    //tabbar middle button click notification
    @objc func tabbarMiddleButtonClick() {
        
        UIView.animate(withDuration: 0.25) {
            self.commandView.transform = CGAffineTransform.identity
            self.coverView.transform = CGAffineTransform.identity
        }
    }
    
    //closeButtonClickCallback
    func closeButtonClickCallback() {
        UIView.animate(withDuration: 0.25) {
            self.commandView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
            self.coverView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
        }
    }
}

//MARK: - textfield/pickerView delegate/datasource
extension CardCommandViewController: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return apduArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return apduArray[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        apduInputField.text = apduArray[row]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CardCommandViewController {
    func printLog(log: String) {
        DispatchQueue.main.async {
            let logMsg = self.logView.text
            let tempLog = log.appending("\n")
            self.logView.text = logMsg?.appending(tempLog)
        }
    }
}
