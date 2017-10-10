//
//  Block.swift
//  Snake
//
//  Created by Brandon Price on 8/21/15.
//  Copyright (c) 2015 Brandon Price. All rights reserved.
//

import SpriteKit

class BackgroundSquare: SKSpriteNode {
    
    init(width: CGFloat, height: CGFloat, xMin: CGFloat, yMin: CGFloat) {
        let texture = SKTexture(imageNamed: "Block")
        super.init(texture: texture, color: UIColor.white, size: texture.size())
        self.position = CGPoint(x: CGFloat(arc4random_uniform(UInt32(width))) + xMin, y: CGFloat(arc4random_uniform(UInt32(height))) + yMin)
        
        let len = CGFloat(Float(UInt32(width/20) + arc4random_uniform(UInt32(width/20))))
        self.size = CGSize(width: len, height: len)
        self.zPosition = 0
        self.alpha = 0.075
        
        // create fade in action
        let FadeIn = SKAction.fadeOut(withDuration: 1.0)
        let Expand = SKAction.scale(by: 2.0, duration: 1.0)
        let Action = SKAction.group([FadeIn,Expand])
        
        let ActionDone = SKAction.removeFromParent()
        self.run(SKAction.sequence([Action, ActionDone]))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
