//
//  GameScene.swift
//  Snake
//
//  Created by Brandon Price on 8/20/15.
//  Copyright (c) 2015 Brandon Price. All rights reserved.
//

import SpriteKit

class HowToPlayScene: SKScene {
    
    // MARK: - Set Up Constants
    var xMax = CGFloat()
    var yMax = CGFloat()
    var xMin = CGFloat()
    var yMin = CGFloat()
    var xMid = CGFloat()
    var yMid = CGFloat()
    var Width = CGFloat()
    var Height = CGFloat()
    var MainMenuButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var PlayButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var SpawnBackgroundSquaresTimer1 = Timer()
    var SpawnBackgroundSquaresTimer2 = Timer()
    
    override func didMove(to _view: SKView) {
        
        // MARK: - Set Up Background
        self.backgroundColor = UIColor.white
        self.StartBackgroundDesign()
        
        // MARK: - Set Up Constants
        self.Height = self.view!.frame.size.height
        self.Width = self.view!.frame.size.width
        self.xMid = self.view!.frame.midX
        self.yMid = self.view!.frame.midY
        self.xMax = xMid + Width/2
        self.xMin = xMid - Width/2
        self.yMax = yMid + Height/2
        self.yMin = yMid - Height/2
        
        // MARK: - Set Up Buttons
        let ButtonSize = CGSize(width: Width * 0.4, height: Height * 0.10)
        
        MainMenuButton = ButtonNode(Size: ButtonSize, Position: CGPoint(x: xMin + ButtonSize.width * 0.5 + 15, y: yMin + ButtonSize.height * 0.5 + 15), Label: "Main Menu")
        MainMenuButton.LabelNode.fontSize = MainMenuButton.size.width/5
        self.addChild(MainMenuButton)
        
        PlayButton = ButtonNode(Size: ButtonSize, Position: CGPoint(x: xMax - ButtonSize.width * 0.5 - 15, y: yMin + ButtonSize.height * 0.5 + 15), Label: "Play")
        PlayButton.LabelNode.fontSize = PlayButton.size.width/5
        self.addChild(PlayButton)
        
        // MARK: - Set Up Instructions
        let LabelArray = ["Swipe to change the snake's direction.","The snake can move out of the boundaries.","Collect shining food blocks to grow the snake.","If the snake hits itself, you lose.","Double-tap the screen to pause the game.","See how long you can survive!"]
        
        for i in 0...LabelArray.count - 1 {
            let LabelNode = SKLabelNode(text: LabelArray[i])
            LabelNode.fontSize = Width/20
            LabelNode.fontColor = UIColor.black
            LabelNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            LabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
            
            LabelNode.position = CGPoint(x: xMid, y: yMid + (CGFloat(LabelArray.count/2) - CGFloat(i)) * (0.075 * Height))
            
            self.addChild(LabelNode)
        }
        
        let Title = SKLabelNode(text: "How To Play")
        Title.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        Title.fontSize = Width/6
        Title.fontColor = UIColor.black
        Title.position = CGPoint(x: xMid, y: yMax - Title.frame.size.height - 0.05 * Height)
        self.addChild(Title)
    }
    
    // MARK: - touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            let _ = CheckTouchesBegan(Location: location, ButtonList: [MainMenuButton,PlayButton])
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            let _ = CheckTouchesMoved(Location: location, ButtonList: [MainMenuButton,PlayButton])
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.location(in: self)
            
            let _ = CheckTouchesLifted(Location: location, ButtonList: [MainMenuButton,PlayButton], ActionList: [OpenMainMenu,PlayGame])
        }
    }
        
    func PlayGame () {
        let gameScene = GameScene(size: self.size)
        let transition = SKTransition.fade(with: UIColor.white, duration: 1.0)
        gameScene.scaleMode = SKSceneScaleMode.resizeFill
        self.scene!.view?.presentScene(gameScene, transition: transition)
    }
    
    func OpenMainMenu () {
        let mainMenuScene = MainMenuScene(size: self.size)
        let transition = SKTransition.fade(with: UIColor.white, duration: 0.5)
        mainMenuScene.scaleMode = SKSceneScaleMode.resizeFill
        self.scene!.view?.presentScene(mainMenuScene, transition: transition)
    }
    
    func StartBackgroundDesign () {
        SpawnBackgroundSquaresTimer1 = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(HowToPlayScene.SpawnSquare), userInfo: nil, repeats: true)
        
        SpawnBackgroundSquaresTimer2 = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(HowToPlayScene.SpawnSquare), userInfo: nil, repeats: true)
    }
    
    @objc func SpawnSquare () {
        let Square = BackgroundSquare(width: Width, height: Height, xMin: xMin, yMin: yMin)
        self.addChild(Square)
    }
}
