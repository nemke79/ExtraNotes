//
//  HelpExtraNotesViewController.swift
//  ExtraNotes
//
//  Created by Nemanja Petrovic on 1/23/19.
//  Copyright © 2019 Nemanja Petrovic. All rights reserved.
//

import UIKit

class HelpExtraNotesViewController: UIViewController {
    
    private let howToUseText = "\n To create Extra Note, tap +. Then choose theme for Extra Note. \n To edit Extra Note, double tap it. One tap allows you to scroll text in selected note. \n To delete, share or add note to Calendar, you need to long press on Extra Note. You can select multiple items for deleting, sharing or adding to Calendar.\n Also, with long press on Extra Note you can move it to another position."
    
    private let rateExtraNotesText = "\n Leave your review and rate Extra Notes in App Store."
    
    private let howToUse = "HOW TO USE"
    private let rateExtraNotes = "\n\nRATE EXTRA NOTES"
    private let contactMe = "\n\nCONTACT ME\n"
    
    private let twitterAttachment = NSTextAttachment()
    
    private var titleFont: UIFont {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(18.0).bold())
    }
    
    private var font: UIFont {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(16.0))
    }
    
    @IBOutlet weak var helpENotesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        twitterAttachment.image = UIImage(named: "Twitter.png")
        
        twitterAttachment.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        let twitterImage = NSAttributedString(attachment: twitterAttachment)
        
        let attrHowToUse = NSAttributedString(string: howToUse, attributes: [.font: titleFont])
        let attrRateExtraNotes = NSAttributedString(string: rateExtraNotes, attributes: [.font:titleFont])
        let attrContactMe = NSAttributedString(string: contactMe, attributes: [.font:titleFont])
        
        let attrHowToUseText = NSAttributedString(string: howToUseText, attributes: [.font: font])
        let attrRateExtraNotesText = NSAttributedString(string: rateExtraNotesText, attributes: [.font:font])
        
        let attributedHelpText = NSMutableAttributedString()
        
        attributedHelpText.append(attrHowToUse)
        attributedHelpText.append(attrHowToUseText)
        attributedHelpText.append(attrRateExtraNotes)
        attributedHelpText.append(attrRateExtraNotesText)
        attributedHelpText.append(attrContactMe)
        attributedHelpText.append(twitterImage)
        
        let linkRangeRate = attributedHelpText.mutableString.range(of: rateExtraNotesText)
        attributedHelpText.addAttribute(NSAttributedString.Key.link, value: "https://twitter.com/Nemke79", range: linkRangeRate)
        
        let linkRangeContact = attributedHelpText.mutableString.range(of: twitterImage.string)
        attributedHelpText.addAttribute(NSAttributedString.Key.link, value: "https://twitter.com/Nemke79", range: linkRangeContact)
        
        helpENotesTextView.attributedText = attributedHelpText
        helpENotesTextView.linkTextAttributes = [
            kCTForegroundColorAttributeName: UIColor.blue
            ] as [NSAttributedString.Key : Any]
    }
    
    // Scroll textview to the top. Needed for small screens - iPhone SE
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        helpENotesTextView.scrollRangeToVisible(NSMakeRange(0, 0))
    }
}
