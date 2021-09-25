//
//  SelectedExtraNoteViewController.swift
//  ExtraNotes
//
//  Created by Nemanja Petrovic on 3/16/18.
//  Copyright © 2018 Nemanja Petrovic. All rights reserved.
//

import UIKit

class SelectedExtraNoteViewController: UIViewController {
    
    @IBOutlet weak var extraNotesTextView: UITextView!
    
    @IBOutlet var toolbar: UIToolbar!
    
    @IBOutlet weak var eNotesImageView: UIImageView!
    
    @IBAction func cancelENote(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func doneENote(_ sender: UIBarButtonItem) {
    }
    
    var extraNotesText: String?
    
    var extraNotesModel: UIImage?
    
    @IBOutlet weak var eNotesImageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var eNotesImageViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var eNotesTextViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var eNotesTextViewBottomConstraint: NSLayoutConstraint!
    
    private var font: UIFont {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(16.0))
    }
    
    @IBOutlet weak var eNotesTextViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var eNotesTextViewRightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.jpg")
        
        view.insertSubview(backgroundImage, at: 0)
        
        extraNotesTextView.becomeFirstResponder()
        
        self.navigationItem.hidesBackButton = true
        
        extraNotesTextView.inputAccessoryView = toolbar
        
        if let text = extraNotesText {
            let attrText = NSAttributedString(string: (text), attributes: [.font: font])
            extraNotesTextView.attributedText = attrText
        }
        
        if extraNotesModel != nil {
            eNotesImageView.image = extraNotesModel
            if eNotesImageView != nil {
                let ratio = extraNotesModel!.size.width / extraNotesModel!.size.height
                let newHeight = eNotesImageView.frame.width / ratio
                eNotesImageViewHeightConstraint.constant = newHeight
                view.layoutIfNeeded()
                
                // If device is with smaller screen then move eNotesImageView up because in other case, keyboard covers it.
                switch UIDevice.current.modelName {
                case "iPhone SE", "iPhone 4", "iPhone 4s", "iPhone 5", "iPhone 5c", "iPhone 5s" :
                    eNotesImageViewTopConstraint.constant = -10
                    eNotesTextViewBottomConstraint.constant = -55
                    eNotesTextViewTopConstraint.constant = 35
                    eNotesTextViewLeftConstraint.constant = 40
                    eNotesTextViewRightConstraint.constant = -40
                    
                case "iPhone XS Max", "iPhone 11 Pro Max", "iPhone 6 Plus", "iPhone 6s Plus", "iPhone 7 Plus", "iPhone 8 Plus", "iPhone XR", "iPhone 11", "iPhone 12", "iPhone 12 Pro", "iPhone 13 Pro", "iPhone 13":
                    eNotesImageViewTopConstraint.constant = 50
                    eNotesTextViewBottomConstraint.constant = -35
                    eNotesTextViewTopConstraint.constant = 20
                    eNotesTextViewLeftConstraint.constant = 60
                    eNotesTextViewRightConstraint.constant = -60
                    
                case  "iPhone 12 Pro Max", "iPhone 13 Pro Max":
                    eNotesImageViewTopConstraint.constant = 50
                    eNotesTextViewBottomConstraint.constant = -35
                    eNotesTextViewTopConstraint.constant = 20
                    eNotesTextViewLeftConstraint.constant = 70
                    eNotesTextViewRightConstraint.constant = -70
                    
                case "iPad Pro (12.9 inch, WiFi)", "iPad Pro (12.9 inch, WiFi+LTE)", "iPad Pro 2nd Gen (WiFi)", "iPad Pro 2nd Gen (WiFi+Cellular)", "iPad Pro 3rd Gen (12.9 inch, WiFi)", "iPad Pro 3rd Gen (12.9 inch, 1TB, WiFi)", "iPad Pro 3rd Gen (12.9 inch, WiFi+Cellular)", "iPad Pro 3rd Gen (12.9 inch, 1TB, WiFi+Cellular)", "iPad Pro 12.9 inch 4th Gen (WiFi)", "iPad Pro 12.9 inch 4th Gen (WiFi+Cellular)", "iPad Pro 12.9 inch 5th Gen":
                    eNotesImageViewTopConstraint.constant = 50
                    eNotesTextViewBottomConstraint.constant = -40
                    eNotesTextViewTopConstraint.constant = 20
                    eNotesTextViewLeftConstraint.constant = 370
                    eNotesTextViewRightConstraint.constant = -370
                    
                case "iPad 7th Gen 10.2-inch (WiFi)", "iPad 7th Gen 10.2-inch (WiFi+Cellular)", "iPad 8th Gen (WiFi)", "iPad 8th Gen (WiFi+Cellular)", "iPad 9th Gen (WiFi)", "iPad 9th Gen (WiFi+Cellular)":
                    eNotesImageViewTopConstraint.constant = 50
                    eNotesTextViewBottomConstraint.constant = -40
                    eNotesTextViewTopConstraint.constant = 20
                    eNotesTextViewLeftConstraint.constant = 270
                    eNotesTextViewRightConstraint.constant = -270
                    
                case "iPad Air 4th Gen (WiFi)", "iPad Air 4th Gen (WiFi+Celular)":
                    eNotesImageViewTopConstraint.constant = 50
                    eNotesTextViewBottomConstraint.constant = -40
                    eNotesTextViewTopConstraint.constant = 20
                    eNotesTextViewLeftConstraint.constant = 270
                    eNotesTextViewRightConstraint.constant = -270
                    
                case "iPad Pro 10.5-inch", "iPad Air (3rd generation)":
                    eNotesImageViewTopConstraint.constant = 50
                    eNotesTextViewBottomConstraint.constant = -40
                    eNotesTextViewTopConstraint.constant = 20
                    eNotesTextViewLeftConstraint.constant = 270
                    eNotesTextViewRightConstraint.constant = -270
                    
                case "iPad Pro 3rd Gen (11 inch, WiFi)", "iPad Pro 3rd Gen (11 inch, 1TB, WiFi)", "iPad Pro 3rd Gen (11 inch, WiFi+Cellular)", "iPad Pro 3rd Gen (11 inch, 1TB, WiFi+Cellular)", "iPad Pro 11 inch 4th Gen (WiFi)", "iPad Pro 11 inch 4th Gen (WiFi+Cellular)", "iPad Pro 11 inch 3rd Gen":
                    eNotesImageViewTopConstraint.constant = 50
                    eNotesTextViewBottomConstraint.constant = -40
                    eNotesTextViewTopConstraint.constant = 20
                    eNotesTextViewLeftConstraint.constant = 270
                    eNotesTextViewRightConstraint.constant = -270
                    
                case "1st Gen iPad Air (China)", "iPad Air (WiFi)", "iPad Air (GSM+CDMA)", "iPad Air 2 (WiFi)", "iPad Air 2 (Cellular)", "iPad Pro (9.7 inch, WiFi)", "iPad Pro (9.7 inch, WiFi+LTE)", "iPad 6th Gen (WiFi)", "iPad 6th Gen (WiFi+Cellular)", "iPad (2017)":
                    eNotesImageViewTopConstraint.constant = 50
                    eNotesTextViewBottomConstraint.constant = -40
                    eNotesTextViewTopConstraint.constant = 20
                    eNotesTextViewLeftConstraint.constant = 240
                    eNotesTextViewRightConstraint.constant = -240
                    
                case "iPad mini Retina (WiFi)", "iPad mini Retina (GSM+CDMA)", "iPad mini Retina (China)" ,"iPad mini 3 (WiFi)", "iPad mini 3 (GSM+CDMA)", "iPad Mini 3 (China)", "iPad mini 4 (WiFi)", "4th Gen iPad mini (WiFi+Cellular)", "iPad mini 5th Gen (WiFi)", "iPad mini 5th Gen", "iPad mini 6th Gen (WiFi)", "iPad mini 6th Gen (WiFi+Cellular)":
                    eNotesImageViewTopConstraint.constant = 50
                    eNotesTextViewBottomConstraint.constant = -40
                    eNotesTextViewTopConstraint.constant = 20
                    eNotesTextViewLeftConstraint.constant = 240
                    eNotesTextViewRightConstraint.constant = -240

                default:
                    eNotesImageViewTopConstraint.constant = 50
                    eNotesTextViewBottomConstraint.constant = -35
                    eNotesTextViewTopConstraint.constant = 20
                    eNotesTextViewLeftConstraint.constant = 40
                    eNotesTextViewRightConstraint.constant = -40
                }
                
                view.addSubview(eNotesImageView)
                eNotesImageView.addSubview(extraNotesTextView)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        extraNotesTextView.resignFirstResponder()
    }
}

extension UIDevice {
    
    var modelName: String {
        
        let identifier: String
        
        if ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] != nil {
            identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
        } else {
            var systemInfo = utsname()
            uname(&systemInfo)
            
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            
            identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
        }
        
        switch identifier {
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,2":                               return "iPhone 7 Plus"
        case "iPhone9,4":                               return "iPhone 7 Plus"
        case "iPhone10,2":                              return "iPhone 8 Plus"
        case "iPhone10,5":                              return "iPhone 8 Plus"
        case "iPhone10,3":                              return "iPhone X"
        case "iPhone10,6":                              return "iPhone X"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4":                              return "iPhone XS Max"
        case "iPhone11,6":                              return "iPhone XS Max"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPhone12,1":                              return "iPhone 11"
        case "iPhone12,3":                              return "iPhone 11 Pro"
        case "iPhone12,5":                              return "iPhone 11 Pro Max"
        case "iPhone12,8":                              return "iPhone SE 2nd Gen"
        case "iPhone13,1":                              return "iPhone 12 Mini"
        case "iPhone13,2":                              return "iPhone 12"
        case "iPhone13,3":                              return "iPhone 12 Pro"
        case "iPhone13,4":                              return "iPhone 12 Pro Max"
        case "iPhone14,2":                              return "iPhone 13 Pro"
        case "iPhone14,3":                              return "iPhone 13 Pro Max"
        case "iPhone14,4":                              return "iPhone 13 Mini"
        case "iPhone14,5":                              return "iPhone 13"
        case "iPad4,1":                                 return "iPad Air (WiFi)"
        case "iPad4,2":                                 return "iPad Air (GSM+CDMA)"
        case "iPad4,3" :                                return "1st Gen iPad Air (China)"
        case "iPad4,4" :                                return "iPad mini Retina (WiFi)"
        case "iPad4,5" :                                return "iPad mini Retina (GSM+CDMA)"
        case "iPad4,6" :                                return "iPad mini Retina (China)"
        case "iPad4,7" :                                return "iPad mini 3 (WiFi)"
        case "iPad4,8" :                                return "iPad mini 3 (GSM+CDMA)"
        case "iPad4,9" :                                return "iPad Mini 3 (China)"
        case "iPad5,1" :                                return "iPad mini 4 (WiFi)"
        case "iPad5,2" :                                return "4th Gen iPad mini (WiFi+Cellular)"
        case "iPad5,3" :                                return "iPad Air 2 (WiFi)"
        case "iPad5,4" :                                return "iPad Air 2 (Cellular)"
        case "iPad6,3" :                                return "iPad Pro (9.7 inch, WiFi)"
        case "iPad6,4" :                                return "iPad Pro (9.7 inch, WiFi+LTE)"
        case "iPad6,7" :                                return "iPad Pro (12.9 inch, WiFi)"
        case "iPad6,8" :                                return "iPad Pro (12.9 inch, WiFi+LTE)"
        case "iPad6,11" :                               return "iPad (2017)"
        case "iPad6,12" :                               return "iPad (2017)"
        case "iPad7,1" :                                return "iPad Pro 2nd Gen (WiFi)"
        case "iPad7,2" :                                return "iPad Pro 2nd Gen (WiFi+Cellular)"
        case "iPad7,3" :                                return "iPad Pro 10.5-inch"
        case "iPad7,4" :                                return "iPad Pro 10.5-inch"
        case "iPad7,5" :                                return "iPad 6th Gen (WiFi)"
        case "iPad7,6" :                                return "iPad 6th Gen (WiFi+Cellular)"
        case "iPad7,11":                                return "iPad 7th Gen 10.2-inch (WiFi)"
        case "iPad7,12":                                return "iPad 7th Gen 10.2-inch (WiFi+Cellular)"
        case "iPad8,1" :                                return "iPad Pro 3rd Gen (11 inch, WiFi)"
        case "iPad8,2" :                                return "iPad Pro 3rd Gen (11 inch, 1TB, WiFi)"
        case "iPad8,3" :                                return "iPad Pro 3rd Gen (11 inch, WiFi+Cellular)"
        case "iPad8,4" :                                return "iPad Pro 3rd Gen (11 inch, 1TB, WiFi+Cellular)"
        case "iPad8,5" :                                return "iPad Pro 3rd Gen (12.9 inch, WiFi)"
        case "iPad8,6" :                                return "iPad Pro 3rd Gen (12.9 inch, 1TB, WiFi)"
        case "iPad8,7" :                                return "iPad Pro 3rd Gen (12.9 inch, WiFi+Cellular)"
        case "iPad8,8" :                                return "iPad Pro 3rd Gen (12.9 inch, 1TB, WiFi+Cellular)"
        case "iPad8,9" :                                return "iPad Pro 11 inch 4th Gen (WiFi)"
        case "iPad8,10" :                                return "iPad Pro 11 inch 4th Gen (WiFi+Cellular)"
        case "iPad8,11":                                return "iPad Pro 12.9 inch 4th Gen (WiFi)"
        case "iPad8,12":                                return "iPad Pro 12.9 inch 4th Gen (WiFi+Cellular)"
        case "iPad11,1":                                return "iPad mini 5th Gen (WiFi)"
        case "iPad11,2":                                return "iPad mini 5th Gen"
        case "iPad11,3":                                return "iPad Air (3rd generation)"
        case "iPad11,4":                                return "iPad Air (3rd generation)"
        case "iPad11,6":                                return "iPad 8th Gen (WiFi)"
        case "iPad11,7":                                return "iPad 8th Gen (WiFi+Cellular)"
        case "iPad12,1" :                               return "iPad 9th Gen (WiFi)"
        case "iPad12,2" :                               return "iPad 9th Gen (WiFi+Cellular)"
        case "iPad14,1" :                               return "iPad mini 6th Gen (WiFi)"
        case "iPad14,2" :                               return "iPad mini 6th Gen (WiFi+Cellular)"
        case "iPad13,1":                                return "iPad Air 4th Gen (WiFi)"
        case "iPad13,2":                                return "iPad Air 4th Gen (WiFi+Celular)"
        case "iPad13,4":                                return "iPad Pro 11 inch 3rd Gen"
        case "iPad13,5":                                return "iPad Pro 11 inch 3rd Gen"
        case "iPad13,6":                                return "iPad Pro 11 inch 3rd Gen"
        case "iPad13,7":                                return "iPad Pro 11 inch 3rd Gen"
        case "iPad13,8":                                return "iPad Pro 12.9 inch 5th Gen"
        case "iPad13,9":                                return "iPad Pro 12.9 inch 5th Gen"
        case "iPad13,10":                                return "iPad Pro 12.9 inch 5th Gen"
        case "iPad13,11":                                return "iPad Pro 12.9 inch 5th Gen"
        default:
            return identifier
        }
    }
}
