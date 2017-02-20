//
//  SwipingCardsCarouselFlowLayout.swift
//  SwipingCardsCarousel
//
//  Created by David Collado on 17/2/17.
//  Copyright © 2017 UXSMobile. All rights reserved.
//

import UIKit

public class SwipingCarouselFlowLayout:  UICollectionViewFlowLayout {
  
  // Mark: Constants
  private struct Constants {
    static let itemWidth: CGFloat = 210       //Width of the Cell.
    static let itemHeight: CGFloat = 330      //Height of the Cell.
    static let minLineSpacing: CGFloat = 20.0
  }
  
  override public func prepare() {
    super.prepare()
    
    itemSize = CGSize(width: Constants.itemWidth, height: Constants.itemHeight)
    scrollDirection = .horizontal
    minimumLineSpacing = Constants.minLineSpacing
    sectionInset = UIEdgeInsetsMake(100.0, (UIScreen.main.bounds.width - Constants.itemWidth) * 0.5, 100, (UIScreen.main.bounds.width - Constants.itemWidth) * 0.5)
  }
  
  // Invalidate the Layout when the user is scrolling
  override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
}
