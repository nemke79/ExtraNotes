//
//  EditSelectedExtraNoteViewController.swift
//  ExtraNotes
//
//  Created by Nemanja Petrovic on 4/4/18.
//  Copyright © 2018 Nemanja Petrovic. All rights reserved.
//

import UIKit

class EditSelectedExtraNoteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var editedExtraNoteTextView: UITextView!
    
    @IBOutlet weak var editedExtraNoteTextViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var toolbar: UIToolbar!
    
    
    @IBAction func cancelENote(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func doneENote(_ sender: UIBarButtonItem) {
    }
    
    
    @IBOutlet weak var editedExtraNoteModelCollectionView: UICollectionView! {
        didSet {
            editedExtraNoteModelCollectionView.dataSource = self
            editedExtraNoteModelCollectionView.delegate = self
        }
    }
    
    private var font: UIFont {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(16.0))
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ExtraNotesModelCollectionViewController.eNotesImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ENotesEditedModelCell", for: indexPath)
        if let eNoteCell = cell as? EditSelectedExtraNoteCollectionViewCell {
            eNoteCell.eNoteImageView.image = ExtraNotesModelCollectionViewController.eNotesImageArray[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0: eNotesImageColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        case 1: eNotesImageColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        case 2: eNotesImageColor = #colorLiteral(red: 0.926846683, green: 0.9133438646, blue: 0.2251782531, alpha: 1)
        case 3: eNotesImageColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        case 4: eNotesImageColor = #colorLiteral(red: 0.9990002513, green: 0.6889510751, blue: 0.3359851241, alpha: 1)
        default: break
        }
        editedExtraNoteTextView.backgroundColor = eNotesImageColor
        editedExtraNoteTextView.setNeedsDisplay()
    }
    
    var extraNotesText: String?
    
    var editedENotesImage: UIImage?
    
    var counter = 0
    
    var eNotesImageColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If device is with bigger screen then change textview bottom constraint because keyboard covers collection view of models for Extra Notes.
        switch UIDevice.current.modelName {
        case "iPhone 6 Plus","iPhone 6s Plus","iPhone 7 Plus","iPhone 8 Plus","iPhone X","iPhone XR","iPhone XS","iPhone XS Max", "iPhone 11", "iPhone 11 Pro", "iPhone 11 Pro Max", "iPhone 12 Mini", "iPhone 12", "iPhone 12 Pro", "iPhone 12 Pro Max":
            editedExtraNoteTextViewBottomConstraint.constant = 360
            
        case "iPad Pro (12.9 inch, WiFi)", "iPad Pro (12.9 inch, WiFi+LTE)", "iPad Pro 2nd Gen (WiFi)", "iPad Pro 2nd Gen (WiFi+Cellular)", "iPad Pro 3rd Gen (12.9 inch, WiFi)", "iPad Pro 3rd Gen (12.9 inch, 1TB, WiFi)", "iPad Pro 3rd Gen (12.9 inch, WiFi+Cellular)", "iPad Pro 3rd Gen (12.9 inch, 1TB, WiFi+Cellular)", "iPad Pro 12.9 inch 4th Gen (WiFi)", "iPad Pro 12.9 inch 4th Gen (WiFi+Cellular)", "iPad Pro 12.9 inch 5th Gen":
            editedExtraNoteTextViewBottomConstraint.constant = 500
            
        case "iPad Pro 10.5-inch", "iPad Air (3rd generation)":
            editedExtraNoteTextViewBottomConstraint.constant = 380
            
        case "iPad 7th Gen 10.2-inch (WiFi)", "iPad 7th Gen 10.2-inch (WiFi+Cellular)", "iPad 8th Gen (WiFi)", "iPad 8th Gen (WiFi+Cellular)":
            editedExtraNoteTextViewBottomConstraint.constant = 380
            
        case "iPad Air 4th Gen (WiFi)", "iPad Air 4th Gen (WiFi+Celular)":
            editedExtraNoteTextViewBottomConstraint.constant = 380
            
        case "iPad Pro 3rd Gen (11 inch, WiFi)", "iPad Pro 3rd Gen (11 inch, 1TB, WiFi)", "iPad Pro 3rd Gen (11 inch, WiFi+Cellular)", "iPad Pro 3rd Gen (11 inch, 1TB, WiFi+Cellular)", "iPad Pro 11 inch 4th Gen (WiFi)", "iPad Pro 11 inch 4th Gen (WiFi+Cellular)", "iPad Pro 11 inch 3rd Gen":
            editedExtraNoteTextViewBottomConstraint.constant = 380
            
        case "1st Gen iPad Air (China)", "iPad Air (WiFi)", "iPad Air (GSM+CDMA)", "iPad Air 2 (WiFi)", "iPad Air 2 (Cellular)", "iPad Pro (9.7 inch, WiFi)", "iPad Pro (9.7 inch, WiFi+LTE)", "iPad 6th Gen (WiFi)", "iPad 6th Gen (WiFi+Cellular)", "iPad (2017)":
            editedExtraNoteTextViewBottomConstraint.constant = 380
            
        case "iPad mini Retina (WiFi)", "iPad mini Retina (GSM+CDMA)", "iPad mini Retina (China)" ,"iPad mini 3 (WiFi)", "iPad mini 3 (GSM+CDMA)", "iPad Mini 3 (China)", "iPad mini 4 (WiFi)", "4th Gen iPad mini (WiFi+Cellular)", "iPad mini (5th generation)":
            editedExtraNoteTextViewBottomConstraint.constant = 380
            
        default:
            editedExtraNoteTextViewBottomConstraint.constant = 305
        }
        
        editedExtraNoteTextView.becomeFirstResponder()
        
        self.navigationItem.hidesBackButton = true
        
        editedExtraNoteTextView.inputAccessoryView = toolbar
        
        if let text = extraNotesText {
            let attrText = NSAttributedString(string: (text), attributes: [.font: font])
            editedExtraNoteTextView.attributedText = attrText
        }
        
        func isEqualImages(image1: UIImage, image2: UIImage) -> Bool {
            let data1: Data? = image1.pngData()
            let data2: Data? = image2.pngData()
            return data1 == data2
        }
        
        if let image = editedENotesImage {
            for eNotesImage in ExtraNotesModelCollectionViewController.eNotesImageArray {
                counter += 1
                if isEqualImages(image1: image, image2: eNotesImage!) {
                    switch counter {
                    case 1: eNotesImageColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
                    case 2: eNotesImageColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                    case 3: eNotesImageColor = #colorLiteral(red: 0.926846683, green: 0.9133438646, blue: 0.2251782531, alpha: 1)
                    case 4: eNotesImageColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
                    case 5: eNotesImageColor = #colorLiteral(red: 0.9990002513, green: 0.6889510751, blue: 0.3359851241, alpha: 1)
                    default: break
                    }
                    editedExtraNoteTextView.backgroundColor = eNotesImageColor
                }
            }
            counter = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Here we scroll ENote to the top with time delay, to avoid situations when scrolling to the top doesn't work.
        let dispatchTime = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.editedExtraNoteTextView.scrollRangeToVisible(NSMakeRange(0, 0))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        editedExtraNoteTextView.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
