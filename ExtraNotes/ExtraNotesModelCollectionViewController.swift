//
//  ShapeCollectionViewController.swift
//  ExtraNotes
//
//  Created by Nemanja Petrovic on 3/14/18.
//  Copyright © 2018 Nemanja Petrovic. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ExtraNotesModelCollectionViewController: UICollectionViewController {
    
    // Array of models for Extra Notes.
    static var eNotesImageArray = [UIImage(named: "blueENote.png"), UIImage(named: "greenENote.png"), UIImage(named: "yellowENote.png"), UIImage(named: "pinkENote.png"), UIImage(named: "orangeENote.png")]
    
    
    @IBAction func cancelModelButton(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.jpg")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        
        collectionView?.backgroundView = backgroundImage
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ExtraNotesModelCollectionViewController.eNotesImageArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ENotesModelCell", for: indexPath)
        if let eNoteCell = cell as? ExtraNotesModelCollectionViewCell {
            eNoteCell.eNoteImageView.image = ExtraNotesModelCollectionViewController.eNotesImageArray[indexPath.item]
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedExtraNote" {
            if let selectedExtraNotesVC = segue.destination.contents as? SelectedExtraNoteViewController {
                if let indexPath = collectionView?.indexPathsForSelectedItems {
                    selectedExtraNotesVC.extraNotesModel = ExtraNotesModelCollectionViewController.eNotesImageArray[indexPath[0].item]
                    selectedExtraNotesVC.extraNotesText = ""
                }
            }
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? navcon
        } else {
            return self
        }
    }
}
