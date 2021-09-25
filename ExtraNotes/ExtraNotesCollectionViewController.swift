//
//  ExtraNotesCollectionViewController.swift
//  ExtraNotes
//
//  Created by Nemanja Petrovic on 3/8/18.
//  Copyright © 2018 Nemanja Petrovic. All rights reserved.
//
//

import UIKit
import CoreData
import MessageUI
import EventKit
import EventKitUI

private let reuseIdentifier = "Cell"

class ExtraNotesCollectionViewController: UICollectionViewController, UITextViewDelegate, MFMailComposeViewControllerDelegate, UICollectionViewDragDelegate, UICollectionViewDropDelegate, UIPopoverPresentationControllerDelegate
{
    
    private var eNotesCount = 0
    private var eNotes: [ExtraNotes]?
    
    private var indexPathOfEditedENoteCell: IndexPath?
    private var indexPathsOfSelectedENoteCells: [IndexPath?] = []
    private var eNotesTextOfSelectedEnoteCells: [String] = []
    
    @IBOutlet weak var deleteENoteButton: UIBarButtonItem!
    
    @IBOutlet weak var calendarENoteButton: UIBarButtonItem!
    
    @IBOutlet weak var shareENoteButton: UIBarButtonItem!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var addENoteButton: UIBarButtonItem!
    
    @IBOutlet weak var helpButton: UIBarButtonItem!
    
    let eventStore = EKEventStore()
    
    @IBAction func sendToCalendarENote(_ sender: Any) {
        let request: NSFetchRequest<ExtraNotes> = ExtraNotes.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: false)]
        request.predicate = NSPredicate(format: "selected = %@", NSNumber(value: true))
        let eNotes = try? context.fetch(request)
        if eNotes!.count > 0 {
            for eNote in eNotes! {
                eNotesTextOfSelectedEnoteCells.append(eNote.text!)
            }
        }
        
        let eNotesToCalendar = eNotesTextOfSelectedEnoteCells.joined(separator: " ")
        
        eventStore.requestAccess( to: EKEntityType.event, completion:{(granted, error) in
            DispatchQueue.main.async {
                if (granted) && (error == nil) {
                    let event = EKEvent(eventStore: self.eventStore)
                    event.title = eNotesToCalendar
                    event.startDate = NSDate() as Date
                    event.endDate = NSDate() as Date
                    let eventController = EKEventEditViewController()
                    eventController.event = event
                    eventController.eventStore = self.eventStore
                    eventController.editViewDelegate = self
                    self.present(eventController, animated: true, completion: nil)
                }
            }
        })
        
        // Next statements are delayed for 0.5 seconds to avoid bug where cells overlap while reloading data, if sendToCalendarENote button is tapped before long press on cell ended.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.reloadDatabase()
            self.longPressDetected = false
            self.helpButton.image = UIImage(named: "Help.png")
            self.helpButton.isEnabled = true
            self.deleteENoteButton.image = nil
            self.deleteENoteButton.isEnabled = false
            self.calendarENoteButton.image = nil
            self.calendarENoteButton.isEnabled = false
            self.shareENoteButton.image = nil
            self.shareENoteButton.isEnabled = false
            self.cancelButton.isHidden = true
            self.addENoteButton.image = UIImage(named: "Plus.png")
            self.addENoteButton.isEnabled = true
            self.navigationItem.title = "ENotes"
            self.navigationItem.setRightBarButton(self.addENoteButton, animated: true)
            self.indexPathsOfSelectedENoteCells.removeAll()
            self.eNotesTextOfSelectedEnoteCells.removeAll()
            
            ExtraNotes.selectedStateToFalseInExtraNotes(in: self.context)
        }
    }
    
    @IBAction func shareENotes(_ sender: Any) {
        let request: NSFetchRequest<ExtraNotes> = ExtraNotes.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: false)]
        request.predicate = NSPredicate(format: "selected = %@", NSNumber(value: true))
        let eNotes = try? context.fetch(request)
        if eNotes!.count > 0 {
            for eNote in eNotes! {
                eNotesTextOfSelectedEnoteCells.append(eNote.text!)
            }
        }
        
        let activityViewController = UIActivityViewController(activityItems: eNotesTextOfSelectedEnoteCells as [Any], applicationActivities: nil)
        
        // Facebook doesn't allow sharing text, so it is excluded from sharing.
        activityViewController.excludedActivityTypes = [.postToFacebook]
        
        
        // For iPad I need to present activityViewController as a popover.
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.barButtonItem = sender as? UIBarButtonItem
        }
        
        present(activityViewController, animated: true, completion: nil)
        
        // Next statements are delayed for 0.5 seconds to avoid bug where cells overlap while reloading data, if shareENotes button is tapped before long press on cell ended.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.reloadDatabase()
            self.longPressDetected = false
            self.helpButton.image = UIImage(named: "Help.png")
            self.helpButton.isEnabled = true
            self.deleteENoteButton.image = nil
            self.deleteENoteButton.isEnabled = false
            self.calendarENoteButton.image = nil
            self.calendarENoteButton.isEnabled = false
            self.shareENoteButton.image = nil
            self.shareENoteButton.isEnabled = false
            self.cancelButton.isHidden = true
            self.addENoteButton.image = UIImage(named: "Plus.png")
            self.addENoteButton.isEnabled = true
            self.navigationItem.title = "ENotes"
            self.navigationItem.setRightBarButton(self.addENoteButton, animated: true)
            self.indexPathsOfSelectedENoteCells.removeAll()
            self.eNotesTextOfSelectedEnoteCells.removeAll()
            
            ExtraNotes.selectedStateToFalseInExtraNotes(in: self.context)
        }
    }
    
    @IBAction func cancelSelectionOfENotes(_ sender: Any) {
        longPressDetected = false
        collectionView?.reloadData()
        helpButton.image = UIImage(named: "Help.png")
        helpButton.isEnabled = true
        deleteENoteButton.image = nil
        deleteENoteButton.isEnabled = false
        calendarENoteButton.image = nil
        calendarENoteButton.isEnabled = false
        shareENoteButton.image = nil
        shareENoteButton.isEnabled = false
        cancelButton.isHidden = true
        addENoteButton.image = UIImage(named: "Plus.png")
        addENoteButton.isEnabled = true
        navigationItem.title = "ENotes"
        navigationItem.setRightBarButton(addENoteButton, animated: true)
        eNotesTextOfSelectedEnoteCells.removeAll()
        indexPathsOfSelectedENoteCells.removeAll()
        
        ExtraNotes.selectedStateToFalseInExtraNotes(in: context)
    }
    
    @IBAction func deleteENotes(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete ENote(s)", style: .destructive){ [weak self] (action: UIAlertAction) -> Void in
            if (self?.indexPathsOfSelectedENoteCells.count)! > 0 {
                self?.collectionView.performBatchUpdates({ [weak self] in
                    ExtraNotes.deleteSelectedExtraNotes(in: (self?.context)!)
                    try? self?.context.save()
                    for indexPathOfSelectedENoteCell in self!.indexPathsOfSelectedENoteCells {
                        self?.collectionView.deleteItems(at: [indexPathOfSelectedENoteCell!])
                        if self?.eNotesCount != 0 {
                            self?.eNotesCount -= 1
                        }
                        self?.reloadDatabase()
                    }
                })
            }
            
            self?.longPressDetected = false
            self?.helpButton.image = UIImage(named: "Help.png")
            self?.helpButton.isEnabled = true
            self?.deleteENoteButton.image = nil
            self?.deleteENoteButton.isEnabled = false
            self?.calendarENoteButton.image = nil
            self?.calendarENoteButton.isEnabled = false
            self?.shareENoteButton.image = nil
            self?.shareENoteButton.isEnabled = false
            self?.cancelButton.isHidden = true
            self?.addENoteButton.image = UIImage(named: "Plus.png")
            self?.addENoteButton.isEnabled = true
            self?.navigationItem.title = "ENotes"
            self?.navigationItem.setRightBarButton(self?.addENoteButton, animated: true)
            self?.indexPathsOfSelectedENoteCells.removeAll()
            self?.eNotesTextOfSelectedEnoteCells.removeAll()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // For iPad I need to present alert as a popover.
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = sender as? UIBarButtonItem
        }
        
        present(alert, animated: true)
    }
    
    var numberOfTaps = 0
    
    var longPressDetected = false
    
    static var persistentContainer: NSPersistentContainer {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    let context = persistentContainer.viewContext
    
    @IBAction func addENotes(_ sender: UIBarButtonItem) {
    }
    
    //MARK: Unwind segues
    
    @IBAction func cancelledENote(segue: UIStoryboardSegue) {
    }
    
    
    @IBAction func createdENote(segue: UIStoryboardSegue) {
        if let selectedExtraNote = segue.source as? SelectedExtraNoteViewController {
            ExtraNotes.addExtraNote(matching: selectedExtraNote, into: context)
            try? context.save()
            reloadDatabase()
            collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
    }
    
    @IBAction func editExtraNote(segue: UIStoryboardSegue) {
        if let editedExtraNote = segue.source as? EditSelectedExtraNoteViewController {
            if indexPathOfEditedENoteCell != nil {
                ExtraNotes.editExtraNote(matching: indexPathOfEditedENoteCell!.item, into: context, with: editedExtraNote.editedExtraNoteTextView.text, and: editedExtraNote.editedExtraNoteTextView.backgroundColor!)
                try? context.save()
                reloadDatabase()
            }
        }
    }
    
    // MARK: View Controller lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eNotesTextOfSelectedEnoteCells.removeAll()
        indexPathsOfSelectedENoteCells.removeAll()
        
        ExtraNotes.selectedStateToFalseInExtraNotes(in: context)
        
        helpButton.image = UIImage(named: "Help.png")
        helpButton.isEnabled = true
        deleteENoteButton.image = nil
        deleteENoteButton.isEnabled = false
        calendarENoteButton.image = nil
        calendarENoteButton.isEnabled = false
        shareENoteButton.image = nil
        shareENoteButton.isEnabled = false
        cancelButton.isHidden = true
        addENoteButton.image = UIImage(named: "Plus.png")
        addENoteButton.isEnabled = true
        navigationItem.title = "ENotes"
        navigationItem.setRightBarButton(addENoteButton, animated: true)
        
        reloadDatabase()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.jpg")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        
        collectionView?.dragDelegate = self
        collectionView?.dropDelegate = self
        collectionView?.dragInteractionEnabled = true
        
        
        collectionView?.backgroundView = backgroundImage
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTap))
        
        doubleTap.cancelsTouchesInView = false
        
        doubleTap.numberOfTapsRequired = 2
        
        doubleTap.delaysTouchesBegan = true
        
        collectionView?.addGestureRecognizer(doubleTap)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap))
        
        tap.numberOfTapsRequired = 1
        
        collectionView?.addGestureRecognizer(tap)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(press))
        
        collectionView?.addGestureRecognizer(longPress)
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        numberOfTaps = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ExtraNotes.selectedStateToFalseInExtraNotes(in: context)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Drag/Drop methods
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if let eNoteCell = collectionView.cellForItem(at: indexPath) as? ExtraNotesCollectionViewCell, let image = eNoteCell.eNoteImageView.image, longPressDetected == false
        {
            // Scroll textview in dragged cell to the top.
            eNoteCell.eNoteTextView.setContentOffset(.zero, animated: true)
            
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: image))
            dragItem.localObject = image
            return [dragItem]
        }
        return []
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        
        let previewParameters = UIDragPreviewParameters()
        previewParameters.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 0)
        
        return previewParameters
    }
    
    
    func collectionView(_ collectionView: UICollectionView, dropPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        
        let previewParamaters = UIDragPreviewParameters()
        previewParamaters.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        return previewParamaters
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal
    {
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                if let _ = item.dragItem.localObject as? UIImage {
                    collectionView.performBatchUpdates({ [weak self] in
                        
                        ExtraNotes.addDraggedExtraNote(matching: sourceIndexPath.item, to: destinationIndexPath.item, into: (self?.context)!)
                        
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                        
                        try? self?.context.save()
                        self?.reloadDatabase()
                    })
                }
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            }
        }
    }
    
    // Use feedbackGenerator to vibrate cell on ended long press Gesture Recognizer or when collides with other cells.
    var feedbackGenerator: UIImpactFeedbackGenerator? = nil
    
    // MARK: Selector for UIGestureRecognizer
    
    @objc func press(sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            feedbackGenerator = UIImpactFeedbackGenerator()
            feedbackGenerator?.prepare()
            
            if let indexPath = collectionView?.indexPathForItem(at: sender.location(in: collectionView)) {
                if let eNoteCell = collectionView?.cellForItem(at: indexPath) as? ExtraNotesCollectionViewCell {
                    eNoteCell.checkMarkImage.image = UIImage(named: "checkMark")
                    ExtraNotes.editSelectedStateExtraNote(matching: indexPath.item, into: context, with: true)
                    try? context.save()
                    longPressDetected = true
                    indexPathsOfSelectedENoteCells.append(indexPath)
                }
            }
        case .ended:
            if let indexPath = collectionView?.indexPathForItem(at: sender.location(in: collectionView)) {
                if let eNoteCell = collectionView?.cellForItem(at: indexPath) as? ExtraNotesCollectionViewCell {
                    eNoteCell.eNoteTextView.isScrollEnabled = false
                }
            }
            feedbackGenerator?.impactOccurred()
            feedbackGenerator = nil
            helpButton.image = nil
            helpButton.isEnabled = false
            deleteENoteButton.image = UIImage(named: "Trash.png")
            deleteENoteButton.isEnabled = true
            calendarENoteButton.image = UIImage(named: "Calendar.png")
            calendarENoteButton.isEnabled = true
            shareENoteButton.image = UIImage(named: "Share.png")
            shareENoteButton.isEnabled = true
            cancelButton.isHidden = false
            addENoteButton.image = nil
            addENoteButton.isEnabled = false
            navigationItem.title = ""
            navigationItem.setRightBarButton(cancelButton, animated: true)
        default: break
        }
    }
    
    @objc func doubleTap(sender: UITapGestureRecognizer) {
        if let indexPath = collectionView?.indexPathForItem(at: sender.location(in: collectionView)) {
            if let _ = collectionView?.cellForItem(at: indexPath) as? ExtraNotesCollectionViewCell, longPressDetected == false {
                numberOfTaps = 2
                performSegue(withIdentifier: "editSelectedENote", sender: indexPath)
                
                indexPathOfEditedENoteCell = indexPath
                
                numberOfTaps = 0
            }
        } else {
            collectionView?.reloadData()
        }
    }
    
    @objc func tap(sender: UITapGestureRecognizer) {
        if let indexPath = collectionView?.indexPathForItem(at: sender.location(in: collectionView)) {
            if let eNoteCell = collectionView?.cellForItem(at: indexPath) as? ExtraNotesCollectionViewCell {
                if longPressDetected == true {
                    if eNoteCell.checkMarkImage.image == nil {
                        eNoteCell.checkMarkImage.image = UIImage(named: "checkMark")
                        ExtraNotes.editSelectedStateExtraNote(matching: indexPath.item, into: context, with: true)
                        try? context.save()
                        indexPathsOfSelectedENoteCells.append(indexPath)
                    } else {
                        eNoteCell.checkMarkImage.image = nil
                        ExtraNotes.editSelectedStateExtraNote(matching: indexPath.item, into: context, with: false)
                        try? context.save()
                        for i in 0..<indexPathsOfSelectedENoteCells.count {
                            if indexPathsOfSelectedENoteCells[i] == indexPath {
                                indexPathsOfSelectedENoteCells.remove(at: i)
                                if indexPathsOfSelectedENoteCells.count == 0 {
                                    eNotesTextOfSelectedEnoteCells.removeAll()
                                    longPressDetected = false
                                    helpButton.image = UIImage(named: "Help.png")
                                    helpButton.isEnabled = true
                                    deleteENoteButton.image = nil
                                    deleteENoteButton.isEnabled = false
                                    calendarENoteButton.image = nil
                                    calendarENoteButton.isEnabled = false
                                    shareENoteButton.image = nil
                                    shareENoteButton.isEnabled = false
                                    cancelButton.isHidden = true
                                    addENoteButton.image = UIImage(named: "Plus.png")
                                    addENoteButton.isEnabled = true
                                    navigationItem.title = "ENotes"
                                    navigationItem.setRightBarButton(addENoteButton, animated: true)
                                }
                                break
                            }
                        }
                    }
                } else {
                    eNoteCell.eNoteTextView.isScrollEnabled = true
                    eNoteCell.eNoteTextView.isUserInteractionEnabled = true
                    eNoteCell.eNoteTextView.isEditable = false
                    eNoteCell.eNoteTextView.isSelectable = false
                }
            }
        }
    }
    
    private func reloadDatabase() {
        let request: NSFetchRequest<ExtraNotes> = ExtraNotes.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: false)]
        
        eNotes = try? context.fetch(request)
        
        if eNotes?.count != nil {
            eNotesCount = eNotes!.count
        }
        
        collectionView?.reloadData()
    }
    
    //   In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSelectedENote" {
            if let editSelectedExtraNotesVC = segue.destination.contents as? EditSelectedExtraNoteViewController {
                if let indexPath = sender as? IndexPath {
                    editSelectedExtraNotesVC.editedENotesImage = eNotes?[indexPath.item].eNotesImage as? UIImage
                    editSelectedExtraNotesVC.extraNotesText = eNotes?[indexPath.item].text
                }
            }
        } else if segue.identifier == "helpENote" {
            if let popoverHelpENoteVC = segue.destination as? HelpExtraNotesViewController {
                popoverHelpENoteVC.popoverPresentationController?.delegate = self
            }
        }
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let btnDone = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneHelp))
        let nav = UINavigationController(rootViewController: controller.presentedViewController)
        nav.topViewController!.navigationItem.rightBarButtonItem = btnDone
        return nav
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        setAlphaOfBackgroundViews(alpha: 1)
    }
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        setAlphaOfBackgroundViews(alpha: 0.7)
    }
    
    func setAlphaOfBackgroundViews(alpha: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.view.alpha = alpha;
            self.navigationController?.navigationBar.alpha = alpha;
        }
    }
    
    @objc func doneHelp(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eNotesCount
    }
    
    private var font: UIFont {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(16.0).italic())
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eNotesCell", for: indexPath)
        if let eNotesCell = cell as? ExtraNotesCollectionViewCell {
            let text = NSAttributedString(string: (eNotes?[indexPath.item].text) ?? "", attributes: [.font: font])
            eNotesCell.eNoteTextView.attributedText = text
            eNotesCell.eNoteTextView.textColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
            eNotesCell.eNoteImageView.image = eNotes?[indexPath.item].eNotesImage as? UIImage
            eNotesCell.eNoteTextView.delegate = self
            eNotesCell.eNoteTextView.isUserInteractionEnabled = false
            if eNotes?[indexPath.item].selected == false {
                eNotesCell.checkMarkImage.image = nil
            } else {
                eNotesCell.checkMarkImage.image = UIImage(named: "checkMark")
            }
        }
        
        return cell
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if numberOfTaps == 2, identifier == "editSelectedENote" {
            return true
        } else if identifier == "addSegue" {
            return true
        } else if identifier == "helpENote"{
            return true
        } else {
            return false
        }
    }
}

extension UIFont {
    func withTraits(traits:UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    
    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}

extension UIBarButtonItem {
    var isHidden: Bool {
        get {
            return tintColor == UIColor.clear
        }
        set(hide) {
            if hide {
                isEnabled = false
                tintColor = UIColor.clear
            } else {
                isEnabled = true
                tintColor = nil
            }
        }
    }
}

extension ExtraNotesCollectionViewController: EKEventEditViewDelegate {
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
        
    }
}
