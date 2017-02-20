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
}

open class SwipingCardsCarouselCollectionViewCell:UICollectionViewCell,UIGestureRecognizerDelegate {
  
  public weak var delegate: SwipingCardsCarouselDelegate?
  
  private var panGestureRecognizer: UIPanGestureRecognizer!
  
  private var animationDirectionY: CGFloat = 1.0
  private var dragBegin = false
  private var dragDistance = CGPoint.zero
  
  fileprivate struct Constants {
    static let rotationMax: CGFloat = 1.0 // Max card rotation
    static let defaultRotationAngle = CGFloat(M_PI) / 10.0
    static let scaleMin: CGFloat = 0.8
    static let SwipeDistanceToTakeAction: CGFloat  = UIScreen.main.bounds.size.height / 5 //Distance required for the cell to go off the screen.
    static let SwipeAnimationDuration: TimeInterval = 0.30 //Duration of the Animation when Swiping Up/Down.
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
    let translation = gestureRecognizer.translation(in: self)
    return abs(translation.x) < abs(translation.y)
  }
  
  private var originalPoint = CGPoint()
  
  
  func panGestureRecognized(_ gestureRecognizer: UIPanGestureRecognizer) {
    dragDistance = gestureRecognizer.translation(in: self)
    
    let touchLocation = gestureRecognizer.location(in: self)
    
    switch gestureRecognizer.state {
    case .began:
      originalPoint = self.center //Get the center of the Cell.
      
      let firstTouchPoint = gestureRecognizer.location(in: self)
      let newAnchorPoint = CGPoint(x: firstTouchPoint.x / bounds.width, y: firstTouchPoint.y / bounds.height)
      let oldPosition = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)
      let newPosition = CGPoint(x: bounds.size.width * newAnchorPoint.x, y: bounds.size.height * newAnchorPoint.y)
      layer.anchorPoint = newAnchorPoint
      layer.position = CGPoint(x: layer.position.x - oldPosition.x + newPosition.x, y: layer.position.y - oldPosition.y + newPosition.y)
      
      dragBegin = true
      
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
  
  func swipeMadeAction(){
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
    let deleteOnSwipeDown = true
    let maxDownPoint: CGPoint = deleteOnSwipeDown ? CGPoint(x: originalPoint.x, y: 2 * frame.maxY) : self.originalPoint
    UIView.animate(withDuration: Constants.SwipeAnimationDuration, animations: { () -> Void in
      self.layer.position = maxDownPoint
      self.superview?.isUserInteractionEnabled = false //Deactivate the user interaction in the Superview (In this case will be in the collection view). To avoid scrolling during the animation.
    }, completion: { (completion) -> Void in
      self.superview?.isUserInteractionEnabled = true // Re-activate the user interaction.
      self.delegate?.cellSwipedDown(self) //Delegate the SwipeDown action and send the view with it.
    })
  }
  
  private func upAction(){
    self.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
    let deleteOnSwipeUp = true
    let maxUpperPoint: CGPoint = deleteOnSwipeUp ? CGPoint(x: originalPoint.x, y: 2 * frame.minY) : self.originalPoint
    UIView.animate(withDuration: Constants.SwipeAnimationDuration, animations: { () -> Void in
      self.layer.position = maxUpperPoint
      self.superview?.isUserInteractionEnabled = false //Deactivate the user interaction in the Superview (In this case will be in the collection view). To avoid scrolling during the animation.
    }, completion: { (completion) -> Void in
      self.superview?.isUserInteractionEnabled = true // Re-activate the user interaction.
      self.delegate?.cellSwipedUp(self) //Delegate the SwipeUp action and send the view with it.
    })
  }
  
  private func resetViewPositionAndTransformations() {
    superview?.isUserInteractionEnabled = false
    UIView.animate(withDuration: Constants.cardResetAnimationDuration, animations: {
      self.layer.transform = CATransform3DIdentity
    }) { _ in
      self.superview?.isUserInteractionEnabled = true
      self.dragBegin = false
    }
  }
  
  open override func prepareForReuse() {
    super.prepareForReuse()
    self.alpha = 1
    self.layer.transform = CATransform3DIdentity
    self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
  }
}


private extension CGPoint {
  // Get the length (a.k.a. magnitude) of the vector
  var length: CGFloat { return sqrt(self.x * self.x + self.y * self.y) }
  
  // Normalize the vector (preserve its direction, but change its magnitude to 1)
  var normalized: CGPoint { return CGPoint(x: self.x / self.length, y: self.y / self.length) }
}
