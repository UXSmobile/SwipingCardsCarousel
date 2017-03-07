//
//  SwipingCardsCarouselFlowLayout.swift
//  SwipingCardsCarousel
//
//  Created by David Collado on 17/2/17.
//  Copyright © 2017 UXSMobile. All rights reserved.
//

import UIKit

public protocol SwipingCardsCarouselFlowLayoutStyle{
  var minLineSpacing: CGFloat {get}
  var topSectionInset: CGFloat? {get}
  var bottomSectionInset: CGFloat? {get}
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
  
  var topSectionInset: CGFloat? {
    get{
      return nil
    }
  }
  
  var bottomSectionInset: CGFloat? {
    get{
      return nil
    }
  }
}

struct DefaultSwipingCardsCarouselStyle:SwipingCardsCarouselFlowLayoutStyle{}

public class SwipingCardsCarouselFlowLayout:  UICollectionViewFlowLayout {
  
  public var stylingDelegate:SwipingCardsCarouselFlowLayoutStyle?
  
  override public func prepare() {
    super.prepare()
    
    let stylingDelegate = self.stylingDelegate ?? DefaultSwipingCardsCarouselStyle()
    
    scrollDirection = .horizontal
    minimumLineSpacing = stylingDelegate.minLineSpacing
    if let collectionView = collectionView, collectionView.frame.height < UIScreen.main.bounds.height{
      // Calculate top and bottom section inset based on custom options
      let topBounds:CGFloat
      let bottomBounds:CGFloat
      if let bottomCustomSectionInset = stylingDelegate.bottomSectionInset{
        topBounds = max(collectionView.bounds.height - stylingDelegate.itemHeight - bottomCustomSectionInset,0)
        bottomBounds = bottomCustomSectionInset
      }else if let topCustomSectionInset = stylingDelegate.topSectionInset{
        topBounds = topCustomSectionInset
        bottomBounds = max(collectionView.bounds.height - stylingDelegate.itemHeight - topCustomSectionInset,0)
      }
      else{
        topBounds = max((collectionView.bounds.height - stylingDelegate.itemHeight) * 0.5,0)
        bottomBounds = max((collectionView.bounds.height - stylingDelegate.itemHeight) * 0.5,0)
      }
      
      let widthBounds = max((collectionView.bounds.width - stylingDelegate.itemWidth) * 0.5,0)
      sectionInset = UIEdgeInsetsMake(topBounds, widthBounds, bottomBounds, widthBounds)
    }
  }
  
  // Invalidate the Layout when the user is scrolling
  override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
}
