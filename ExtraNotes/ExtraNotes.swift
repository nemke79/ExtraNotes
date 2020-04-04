//
//  ExtraNotes.swift
//  ExtraNotes
//
//  Created by Nemanja Petrovic on 3/8/18.
//  Copyright © 2018 Nemanja Petrovic. All rights reserved.
//

import UIKit
import CoreData

class ExtraNotes: NSManagedObject {
    class func addExtraNote(matching selectedExtraNote: SelectedExtraNoteViewController, into context: NSManagedObjectContext){
        let extraNote = ExtraNotes(context: context)
        extraNote.text = selectedExtraNote.extraNotesTextView.text
        extraNote.eNotesImage = selectedExtraNote.eNotesImageView.image
        extraNote.createdDate = Date()
        extraNote.selected = false
    }
    
    class func addDraggedExtraNote(matching sourceItem: Int, to destinationItem: Int, into context: NSManagedObjectContext)
    {
        let request: NSFetchRequest<ExtraNotes> = ExtraNotes.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: false)]
        let eNotes = try? context.fetch(request)
        if eNotes?.count != nil {
            let sourceItemCreatedDate = eNotes![sourceItem].createdDate
            eNotes![sourceItem].createdDate = eNotes![destinationItem].createdDate
            
            if destinationItem < sourceItem {
                for item in destinationItem..<sourceItem {
                    if (item + 1) != sourceItem {
                        eNotes![item].createdDate = eNotes![item + 1].createdDate
                    } else {
                        eNotes![item].createdDate = sourceItemCreatedDate
                    }
                }
            } else if destinationItem > sourceItem {
                for item in stride(from: destinationItem, to: sourceItem, by: -1)
                {
                    if (item - 1) == sourceItem {
                        eNotes![item].createdDate = sourceItemCreatedDate
                    } else {
                        eNotes![item].createdDate = eNotes![item - 1].createdDate
                    }
                }
            }
        }
    }
    
    class func editExtraNote(matching item: Int, into context: NSManagedObjectContext, with text: String, and color: UIColor) {
        let request: NSFetchRequest<ExtraNotes> = ExtraNotes.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: false)]
        let eNotes = try? context.fetch(request)
        if eNotes?.count != nil {
            eNotes?[item].text = text
            switch color {
            case #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1): eNotes?[item].eNotesImage = ExtraNotesModelCollectionViewController.eNotesImageArray[0]
            case #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1): eNotes?[item].eNotesImage = ExtraNotesModelCollectionViewController.eNotesImageArray[1]
            case #colorLiteral(red: 0.926846683, green: 0.9133438646, blue: 0.2251782531, alpha: 1): eNotes?[item].eNotesImage = ExtraNotesModelCollectionViewController.eNotesImageArray[2]
            case #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1): eNotes?[item].eNotesImage = ExtraNotesModelCollectionViewController.eNotesImageArray[3]
            case #colorLiteral(red: 0.9990002513, green: 0.6889510751, blue: 0.3359851241, alpha: 1): eNotes?[item].eNotesImage = ExtraNotesModelCollectionViewController.eNotesImageArray[4]
            default: break
            }
        }
    }
    
    class func deleteExtraNote(matching item: Int, into context: NSManagedObjectContext) {
        let request: NSFetchRequest<ExtraNotes> = ExtraNotes.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: false)]
        let eNotes = try? context.fetch(request)
        if eNotes!.count > 0 {
            context.delete(eNotes![item])
        }
    }
    
    class func selectedStateToFalseInExtraNotes(in context: NSManagedObjectContext) {
        let request: NSFetchRequest<ExtraNotes> = ExtraNotes.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: false)]
        request.predicate = NSPredicate(format: "selected = %@", NSNumber(value: true))
        let eNotes = try? context.fetch(request)
        if eNotes!.count > 0 {
            for eNote in eNotes! {
                eNote.selected = false
            }
        }
    }
    
    class func deleteSelectedExtraNotes(in context: NSManagedObjectContext) {
        let request: NSFetchRequest<ExtraNotes> = ExtraNotes.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: false)]
        request.predicate = NSPredicate(format: "selected = %@", NSNumber(value: true))
        let eNotes = try? context.fetch(request)
        if eNotes!.count > 0 {
            for eNote in eNotes! {
                context.delete(eNote)
            }
        }
    }
    
    class func editSelectedStateExtraNote(matching item: Int, into context: NSManagedObjectContext, with selected: Bool) {
        let request: NSFetchRequest<ExtraNotes> = ExtraNotes.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending: false)]
        let eNotes = try? context.fetch(request)
        if eNotes?.count != nil {
            eNotes?[item].selected = selected
        }
    }
}
