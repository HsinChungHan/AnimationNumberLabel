//
//  AnimationNumberLabel.swift
//  DisplayLink
//
//  Created by Chung Han Hsin on 2020/5/26.
//  Copyright © 2020 Chung Han Hsin. All rights reserved.
//

import UIKit

//MARK: - AnimationNumberLabelDataSource
public protocol AnimationNumberLabelDataSource: AnyObject {
  
  func animationNumberLabelStartValue(_ animationNumberLabel: AnimationNumberLabel) -> Int
  func animationNumberLabelEndValue(_ animationNumberLabel: AnimationNumberLabel) -> Int
  
  func animationNumberLabelDuration(_ animationNumberLabel: AnimationNumberLabel) -> TimeInterval
  
  func animationNumberLabelBackgroundColor(_ animationNumberLabel: AnimationNumberLabel) -> UIColor
  
  func animationNumberLabelTextColor(_ animationNumberLabel: AnimationNumberLabel) -> UIColor
  
  func animationNumberLabelFont(_ animationNumberLabel: AnimationNumberLabel) -> UIFont
  
  func animationNumberLabelTextAlignment(_ animationNumberLabel: AnimationNumberLabel) -> NSTextAlignment
  
}

public class AnimationNumberLabel: UILabel {
  //MARK: - Properties
  public weak var dataSource: AnimationNumberLabelDataSource?
  
  var animationStartDate: Date?
  var displayLink: CADisplayLink?
  
  //MARK: - View life cycle
  override init(frame: CGRect) {
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public func draw(_ rect: CGRect) {
    super.draw(.zero)
    guard let dataSource = dataSource else {
      fatalError("You have to set dataSource for AnimationNumberLabel")
    }
    
    font = dataSource.animationNumberLabelFont(self)
    textColor = dataSource.animationNumberLabelTextColor(self)
    backgroundColor = dataSource.animationNumberLabelBackgroundColor(self)
    textAlignment = dataSource.animationNumberLabelTextAlignment(self)
  }
  
  @objc func handleDisplayLink() {
    guard let dataSource = dataSource else {
      fatalError("You have to set dataSource for AnimationNumberLabel")
    }
    let startValue = dataSource.animationNumberLabelStartValue(self)
    let endValue = dataSource.animationNumberLabelEndValue(self)
    let duration = dataSource.animationNumberLabelDuration(self)
    guard let animationStartDate = animationStartDate else {
      return
    }
    let now = Date()
    let elaspedTime = now.timeIntervalSince(animationStartDate)
    if elaspedTime > duration {
      text = "\(endValue)"
      invalidateDisplayLink()
    } else {
      let percentage = elaspedTime / duration
      let value = Int(Double(startValue) + percentage * Double(endValue - startValue))
      text = "\(value)"
    }
  }
}

//MARK: - Public functions
extension AnimationNumberLabel {
  
  public func launchDisplayLink() {
    animationStartDate = Date()
    displayLink = CADisplayLink(target: self, selector: #selector(handleDisplayLink))
    displayLink?.add(to: .main, forMode: .default)
  }
  
  public func invalidateDisplayLink() {
    displayLink?.invalidate()
    displayLink = nil
  }
}
