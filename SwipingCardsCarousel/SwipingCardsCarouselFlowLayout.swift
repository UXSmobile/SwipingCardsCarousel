//
//  SwipingCardsCarouselFlowLayout.swift
//  SwipingCardsCarousel
//
//  Created by David Collado on 17/2/17.
//  Copyright © 2017 UXSMobile. All rights reserved.
//

import UIKit

public protocol SwipingCardsCarouselFlowLayoutStyle{
  var itemWidth:CGFloat {get}
  var itemHeight: CGFloat {get}
  var minLineSpacing: CGFloat {get}
}

public extension SwipingCardsCarouselFlowLayoutStyle{
  var itemWidth:CGFloat {
    get{
      return 210
    }
  }
  var itemHeight: CGFloat {
    get{
      return 330
    }
  }
  var minLineSpacing: CGFloat {
    get{
      return 20
    }
  }
}

struct DefaultSwipingCardsCarouselStyle:SwipingCardsCarouselFlowLayoutStyle{}

public class SwipingCardsCarouselFlowLayout:  UICollectionViewFlowLayout {
  
  public var stylingDelegate:SwipingCardsCarouselFlowLayoutStyle?
  
  override public func prepare() {
    super.prepare()
    
    let stylingDelegate = self.stylingDelegate ?? DefaultSwipingCardsCarouselStyle()
    
    itemSize = CGSize(width: stylingDelegate.itemWidth, height: stylingDelegate.itemHeight)
    scrollDirection = .horizontal
    minimumLineSpacing = stylingDelegate.minLineSpacing
    sectionInset = UIEdgeInsetsMake(100.0, (UIScreen.main.bounds.width - stylingDelegate.itemWidth) * 0.5, 100, (UIScreen.main.bounds.width - stylingDelegate.itemWidth) * 0.5)
  }
  
  // Invalidate the Layout when the user is scrolling
  override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
}
