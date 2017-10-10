//
//  Block.swift
//  Snake
//
//  Created by Brandon Price on 8/21/15.
//  Copyright (c) 2015 Brandon Price. All rights reserved.
//

import SpriteKit

class Block: SKSpriteNode {
    var Coordinates = CGPoint()
    var BlockNumber = CGFloat()
    var TotalBlockAmount = CGFloat()
    
    init(Coordinate: CGPoint, BlockNum: CGFloat, TotalBlocks: CGFloat) {
        self.TotalBlockAmount = TotalBlocks
        self.BlockNumber = BlockNum
        self.Coordinates = Coordinate
        super.init(texture: nil, color: UIColor.black, size: CGSize())
        self.zPosition = TotalBlockAmount - BlockNumber
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func BlockNumChange (NewBlockNum: CGFloat, NewTotalBlocks: CGFloat) {
        self.TotalBlockAmount = NewTotalBlocks
        self.BlockNumber = NewBlockNum
        self.alpha = 0.9 * (self.TotalBlockAmount - self.BlockNumber) / self.TotalBlockAmount + 0.15
    }
}
