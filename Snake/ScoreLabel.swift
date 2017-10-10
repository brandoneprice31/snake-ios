//
//  ScoreLabel.swift
//  Snake
//
//  Created by Brandon Price on 9/15/15.
//  Copyright (c) 2015 Brandon Price. All rights reserved.
//

import SpriteKit

class ScoreLabel: SKLabelNode {
    
    var Action = SKAction()
   
    init(Text: String) {
        
        super.init()
        
        self.alpha = 0.0
        self.zPosition = 200
        self.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        let FadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.25)
        let FadeOut = SKAction.fadeAlpha(to: 0.0, duration: 0.25)
        
        Action = SKAction.sequence([FadeIn,FadeOut])
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func QuickAppearance () {
        self.run(Action)
    }
    
    func Show () {
        self.removeAllActions()
        self.alpha = 1.0
    }
    
    func Hide () {
        self.removeAllActions()
        self.alpha = 0.0
    }
    
}
