//
//  ViewController.swift
//  ExampleProject
//
//  Created by David Collado on 17/2/17.
//  Copyright © 2017 UXSMobile. All rights reserved.
//

import UIKit

class CardCollectionViewCell: SwipingCardsCarouselCollectionViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var professionLabel: UILabel!
  @IBOutlet weak var mainDescriptionLabel: UILabel!
  @IBOutlet weak var activityLabel: UILabel!
  
  static let reuseIdentifier = "CardCollectionViewCell"
  static var nib: UINib {
    get {
      return UINib(nibName: "CardCollectionViewCell", bundle: nil)
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Cell Corner and Shadows
    layer.masksToBounds = false
    layer.cornerRadius = 10
    layer.shadowRadius = 5
    layer.shadowOpacity = 0.6
    // Emphasize the shadow on the bottom and right sides of the cell
    layer.shadowOffset = CGSize(width: 4, height: 4)
  }
  
  func populateWith(card: Card) {
    nameLabel.text = card.name
    professionLabel.text = card.profession
    mainDescriptionLabel.text = card.mainDescription
    activityLabel.text = card.activity
    backgroundColor = card.backgroundColor
  }
}
