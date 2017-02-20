//
//  ViewController.swift
//  ExampleProject
//
//  Created by David Collado on 17/2/17.
//  Copyright © 2017 UXSMobile. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView! { didSet {
    collectionView.register(CardCollectionViewCell.nib, forCellWithReuseIdentifier: CardCollectionViewCell.reuseIdentifier)
    }
  }
  
  // MARK: Model
  // Load allTheCards from SavedCards Class.
  fileprivate var allTheCards = Card.loadCards()
  
}

// MARK: UICollectionView DataSource
extension CardViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //Return the number of items in the section
    return allTheCards.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.reuseIdentifier, for: indexPath) as! CardCollectionViewCell
    // Configure the cell
    cell.delegate = self
    cell.populateWith(card: allTheCards[(indexPath as NSIndexPath).row])
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
  }
  
}

// MARK: Conform to the SwipingCarousel Delegate
extension CardViewController: SwipingCardsCarouselDelegate {
  
  func cellSwipedUp(_ cell: UICollectionViewCell) {
    guard let cell = cell as? CardCollectionViewCell else { return }
    print("Swiped Down - Card to Delete: \(cell.nameLabel.text!)")
    if let indexPath = collectionView?.indexPath(for: cell) {
      //Delete the swiped card from the Model.
      allTheCards.remove(at: (indexPath as NSIndexPath).row)
      //Delete the swiped card from CollectionView.
      collectionView?.deleteItems(at: [indexPath])
      //Delete cell from View.
      cell.removeFromSuperview()
    }
  }
  
  func cellSwipedDown(_ cell: UICollectionViewCell) {
    
    guard let cell = cell as? CardCollectionViewCell else { return }
    print("Swiped Down - Card to Delete: \(cell.nameLabel.text!)")
    if let indexPath = collectionView?.indexPath(for: cell) {
      //Delete the swiped card from the Model.
      allTheCards.remove(at: (indexPath as NSIndexPath).row)
      //Delete the swiped card from CollectionView.
      collectionView?.deleteItems(at: [indexPath])
      //Delete cell from View.
      cell.removeFromSuperview()
    }
  }
}

