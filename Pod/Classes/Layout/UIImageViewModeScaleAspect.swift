//
//  UIImageViewModeScaleAspect.swift
//  Pods
//
//  Created by chenyungui on 2017/1/3.
//
//

import Foundation
import UIKit

public class UIImageViewModeScaleAspect : UIView {
    
    public var newFrameWrapper: CGRect = .zero
    public var newFrameImg: CGRect = .zero
    public var img: UIImageView!
    
    public var image: UIImage? {
        get { return self.img.image }
        set { self.img.image = newValue }
    }

    public var imageContentMode: UIViewContentMode {
        get { return self.img.contentMode }
        set { self.img.contentMode = newValue }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setup()
        self.img.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.img = UIImageView(frame: self.bounds)
        self.img.contentMode = .center
        self.addSubview(img)
        self.clipsToBounds = true
    }
    
    public func animateToScaleAspectFit(to frame: CGRect, with duration: TimeInterval, after delay: TimeInterval) {

        guard !self.uiImageIsEmpty() else { return }
        self.initToScaleAspectFit(to: frame)
        
        UIView.animate(withDuration: duration, delay: delay, options: [.allowUserInteraction], animations: { 
            self.animaticToScaleAspectFit()
        }, completion: nil )
    }
    
    public func animateToScaleAspectFill(to frame: CGRect, with duration: TimeInterval, after delay: TimeInterval) {
    
        guard !self.uiImageIsEmpty() else { return }
        
        self.initToScaleAspectFill(to: frame)
        
        UIView.animate(withDuration: duration, delay: delay, options: [.allowUserInteraction], animations: { 
            self.animaticToScaleAspectFill()
        }, completion: { _ in
            self.animateFinishToScaleAspectFill()
        })
    }
    
    
    public func animateToScaleAspectFit(to frame: CGRect, with duration: TimeInterval, after delay: TimeInterval, completion: @escaping (Bool)->Void) {
    
        if !self.uiImageIsEmpty() {
            self.initToScaleAspectFit(to: frame)
            UIView.animate(withDuration: duration, delay: delay, options: [.allowUserInteraction], animations: { 
                self.animaticToScaleAspectFit()
            }, completion: { _ in
                completion(true)
            })
        } else {
            completion(true)
        }
    }
    
    public func animateToScaleAspectFill(to frame: CGRect, with duration: TimeInterval, after delay: TimeInterval, completion: @escaping (Bool)->Void) {
    
        if !self.uiImageIsEmpty() {
            self.initToScaleAspectFill(to: frame)
            UIView.animate(withDuration: duration, delay: delay, options: [.allowUserInteraction], animations: {
                self.animaticToScaleAspectFill()
            }, completion: { _ in
                self.animateFinishToScaleAspectFill()
                completion(true)
            })
        } else {
            completion(true)
        }
    }
    
    public func animaticToScaleAspectFit() {
    
        self.img.frame = newFrameImg
        self.frame = newFrameWrapper
    }
    
    public func animaticToScaleAspectFill() {
    
        self.img.frame = newFrameImg
        self.frame = newFrameWrapper
    }
    
    public func animateFinishToScaleAspectFit() {}
    
    public func animateFinishToScaleAspectFill() {
    
        self.img.contentMode = .scaleAspectFill
        self.img.frame  = self.bounds
    }

    
    private func uiImageIsEmpty() -> Bool {
        if self.img.image?.cgImage != nil {
            return false
        }
        if self.img.image?.ciImage != nil {
            return false
        }
        return true
    }

    private func choiseFunctionWithRationImg(ratioImg: CGFloat, for newFrame: CGRect) -> Bool {
    
        let ratioSelf = newFrame.size.width / newFrame.size.height
    
        if ratioImg < 1 {
            if ratioImg > ratioSelf { return true }
        }else{
            if ratioImg > ratioSelf { return true }
        }
        return false
    }

    public func initToScaleAspectFit(to newFrame: CGRect) {
        
        if !self.uiImageIsEmpty() {
        
            let size = self.image!.size
            let ratioImg = size.width / size.height
        
            if self.choiseFunctionWithRationImg(ratioImg: ratioImg, for: self.frame) {
                let x = -(self.frame.size.height * ratioImg - self.frame.size.width) / 2.0
                self.img.frame = CGRect(x: x, y: 0, width: self.frame.size.height * ratioImg, height: self.frame.size.height)
            } else {
                let y =  -(self.frame.size.width / ratioImg - self.frame.size.height) / 2.0
                self.img.frame = CGRect(x: 0, y: y, width: self.frame.size.width, height: self.frame.size.width / ratioImg)
            }
        }
        
        img.contentMode = .scaleAspectFit
        self.newFrameImg = CGRect(x: 0, y: 0, width: newFrame.size.width, height: newFrame.size.height)
        self.newFrameWrapper = newFrame
    }
    
    public func initToScaleAspectFill(to newFrame: CGRect) {
        
        if !self.uiImageIsEmpty() {
            let ratioImg = image!.size.width / image!.size.height
            
            if self.choiseFunctionWithRationImg(ratioImg: ratioImg, for: newFrame) {
                let x = -(newFrame.size.height * ratioImg - newFrame.size.width) / 2.0
                self.newFrameImg = CGRect(x: x, y: 0, width: newFrame.size.height * ratioImg, height: newFrame.size.height)
            } else {
                let y = -(newFrame.size.width / ratioImg - newFrame.size.height) / 2.0
                self.newFrameImg = CGRect(x: 0, y: y, width: newFrame.size.width, height: newFrame.size.width / ratioImg)
            }
        }
        self.newFrameWrapper = newFrame
    }
}

















