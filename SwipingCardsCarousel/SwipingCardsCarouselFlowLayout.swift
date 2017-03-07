//
//  SwipingCardsCarouselFlowLayout.swift
//  SwipingCardsCarousel
//
//  Created by David Collado on 17/2/17.
//  Copyright © 2017 UXSMobile. All rights reserved.
//

import UIKit

public class SwipingCardsCarouselFlowLayout:  UICollectionViewFlowLayout {
  
  override public func prepare() {
    super.prepare()
    
    scrollDirection = .horizontal
  }
  
  // Invalidate the Layout when the user is scrolling
  override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
}
