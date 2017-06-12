//
//  TouchFunctions.swift
//  Snake
//
//  Created by Brandon Price on 11/4/15.
//  Copyright © 2015 Brandon Price. All rights reserved.
//

import Foundation
import SpriteKit

let LightColor = UIColor(white: 0.9, alpha: 1.0)
let MediumColor = UIColor(white: 0.5, alpha: 1.0)
let DarkColor = UIColor(white: 0.3, alpha: 1.0)

func CheckTouchesBegan (Location: CGPoint, ButtonList: [ButtonNode]) -> Bool{

    for i in 0...ButtonList.count-1 {
        if (ButtonList[i].frame.minX <= Location.x && Location.x <= ButtonList[i].frame.maxX) && (ButtonList[i].frame.minY <= Location.y && Location.y <= ButtonList[i].frame.maxY) {
            
            // darken PlayAgainButton
            ButtonList[i].color = DarkColor
            ButtonList[i].LabelNode.fontColor = UIColor.whiteColor()
            ButtonList[i].Clicked = true
            
            return true

        }
    }
    
    return false
}

func TouchesMovedOut (Location: CGPoint, ButtonList: [ButtonNode]) -> Bool {
    
    for i in 0...ButtonList.count-1 {
        
        if (ButtonList[i].frame.minX <= Location.x && Location.x <= ButtonList[i].frame.maxX) && (ButtonList[i].frame.minY <= Location.y && Location.y <= ButtonList[i].frame.maxY) {
            return false
        }
        
    }
    
    return true
}

func CheckTouchesMoved (Location: CGPoint, ButtonList: [ButtonNode]) -> Bool {
    
    if TouchesMovedOut(Location, ButtonList: ButtonList) {
        
        for i in 0...ButtonList.count-1 {
            
            ButtonList[i].color = LightColor
            ButtonList[i].LabelNode.fontColor = UIColor.blackColor()
            ButtonList[i].Clicked = false
            
        }
        
        return true
    }
    
    return false
    
}

func CheckTouchesLifted (Location: CGPoint, ButtonList: [ButtonNode], ActionList: [() -> ()]) -> Bool {
    
    for i in 0...ButtonList.count-1 {
        if (ButtonList[i].frame.minX <= Location.x && Location.x <= ButtonList[i].frame.maxX) && (ButtonList[i].frame.minY <= Location.y && Location.y <= ButtonList[i].frame.maxY && ButtonList[i].Clicked) {
            
            // Perform Action
            ActionList[i] ()
            
            return true
            
        }
    }
    
    return false
}




