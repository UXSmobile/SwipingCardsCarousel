//
//  SwipingCardsCarouselCollectionViewCell.swift
//  ExampleProject
//
//  Created by David Collado on 17/2/17.
//  Copyright © 2017 UXSMobile. All rights reserved.
//

import UIKit

//Protocol to inform that cell is being swiped up or down.
public protocol SwipingCardsCarouselDelegate : class {
  func cellSwipedUp(_ cell: UICollectionViewCell)
  func cellSwipedDown(_ cell: UICollectionViewCell)
  func shouldSwipe(_ cell: UICollectionViewCell) -> Bool
}

open class SwipingCardsCarouselCollectionViewCell:UICollectionViewCell,UIGestureRecognizerDelegate {
  
  public weak var delegate: SwipingCardsCarouselDelegate?
  
  private var panGestureRecognizer: UIPanGestureRecognizer!
  
  private var animationDirectionY: CGFloat = 1.0
  private var dragDistance = CGPoint.zero
  
  fileprivate struct Constants {
    static let rotationMax: CGFloat = 1.0
    static let defaultRotationAngle = CGFloat(M_PI) / 10.0
    static let scaleMin: CGFloat = 0.8
    static let SwipeDistanceToTakeAction: CGFloat  = UIScreen.main.bounds.size.height / 5
    static let SwipeAnimationDuration: TimeInterval = 0.30
    static let cardResetAnimationDuration: TimeInterval = 0.2
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  public required init(coder: NSCoder) {
    super.init(coder: coder)!
    setup()
  }
  
  deinit {
    removeGestureRecognizer(panGestureRecognizer)
  }
  
  private func setup(){
    panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognized(_:)))
    addGestureRecognizer(panGestureRecognizer)
    panGestureRecognizer.delegate = self
  }
  
  open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    guard let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {return false}
    guard delegate?.shouldSwipe(self) ?? true else {return false}
    let translation = gestureRecognizer.translation(in: self)
    return abs(translation.x) < abs(translation.y)
  }
  
  private var originalPoint = CGPoint()
  
  
  func panGestureRecognized(_ gestureRecognizer: UIPanGestureRecognizer) {
    dragDistance = gestureRecognizer.translation(in: self)
    
    let touchLocation = gestureRecognizer.location(in: self)
    
    switch gestureRecognizer.state {
    case .began:
      originalPoint = self.center
      
      let firstTouchPoint = gestureRecognizer.location(in: self)
      let newAnchorPoint = CGPoint(x: firstTouchPoint.x / bounds.width, y: firstTouchPoint.y / bounds.height)
      let oldPosition = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
      let newPosition = CGPoint(x: bounds.size.width * newAnchorPoint.x, y: bounds.size.height * newAnchorPoint.y)
      layer.anchorPoint = newAnchorPoint
      layer.position = CGPoint(x: layer.position.x - oldPosition.x + newPosition.x, y: layer.position.y - oldPosition.y + newPosition.y)
      
      
      animationDirectionY = touchLocation.y >= frame.size.height / 2 ? -1.0 : 1.0
      layer.rasterizationScale = UIScreen.main.scale
      layer.shouldRasterize = true
      
    case .changed:
      let rotationStrength = min(dragDistance.x / frame.width, Constants.rotationMax)
      let rotationAngle = animationDirectionY * Constants.defaultRotationAngle * rotationStrength
      let scaleStrength = 1 - ((1 - Constants.scaleMin) * fabs(rotationStrength))
      let scale = max(scaleStrength, Constants.scaleMin)
      
      var transform = CATransform3DIdentity
      transform = CATransform3DScale(transform, scale, scale, 1)
      transform = CATransform3DRotate(transform, rotationAngle, 0, 0, 1)
      transform = CATransform3DTranslate(transform, dragDistance.x, dragDistance.y, 0)
      layer.transform = transform
      
    case .ended:
      swipeMadeAction()
      
      layer.shouldRasterize = false
      
    default:
      layer.shouldRasterize = false
      resetViewPositionAndTransformations()
    }
  }
  
  private func swipeMadeAction(){
    let swipeDistanceOnY = dragDistance.y
    
    if swipeDistanceOnY > Constants.SwipeDistanceToTakeAction {
      downAction()
    } else if swipeDistanceOnY < -Constants.SwipeDistanceToTakeAction {
      upAction()
    }else{
      resetViewPositionAndTransformations()
    }
  }
  
  private func downAction(){
    self.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
    let maxDownPoint: CGPoint = CGPoint(x: originalPoint.x, y: 2 * frame.maxY)
    UIView.animate(withDuration: Constants.SwipeAnimationDuration, animations: { () -> Void in
      self.layer.position = maxDownPoint
      self.superview?.isUserInteractionEnabled = false
    }, completion: { (completion) -> Void in
      self.superview?.isUserInteractionEnabled = true
      self.delegate?.cellSwipedDown(self)
    })
  }
  
  private func upAction(){
    self.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
    let maxUpperPoint: CGPoint = CGPoint(x: originalPoint.x, y: 2 * frame.minY)
    UIView.animate(withDuration: Constants.SwipeAnimationDuration, animations: { () -> Void in
      self.layer.position = maxUpperPoint
      self.superview?.isUserInteractionEnabled = false
    }, completion: { (completion) -> Void in
      self.superview?.isUserInteractionEnabled = true
      self.delegate?.cellSwipedUp(self)
    })
  }
  
  private func resetViewPositionAndTransformations() {
    superview?.isUserInteractionEnabled = false
    UIView.animate(withDuration: Constants.cardResetAnimationDuration, animations: {
      self.layer.transform = CATransform3DIdentity
    }) { _ in
      self.superview?.isUserInteractionEnabled = true
    }
  }
  
  open override func prepareForReuse() {
    super.prepareForReuse()
    self.alpha = 1
    self.layer.transform = CATransform3DIdentity
    self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
  }
}
