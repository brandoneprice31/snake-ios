//
//  ButtonNode.swift
//  Snake
//
//  Created by Brandon Price on 11/4/15.
//  Copyright © 2015 Brandon Price. All rights reserved.
//

import SpriteKit

class ButtonNode: SKSpriteNode {

    
    var Clicked = Bool()
    var LabelNode = SKLabelNode()
    
    init (Size: CGSize, Position: CGPoint, Label: String) {

        super.init(texture: nil, color: LightColor, size: Size)
        Clicked = false
        self.position = Position
        self.LabelNode = SKLabelNode(text: Label)
        LabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        LabelNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        LabelNode.fontColor = UIColor.blackColor()
        LabelNode.zPosition = 1001
        LabelNode.fontSize = Size.height / 1.5
        self.zPosition = 1000
        self.addChild(LabelNode)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}