//
//  MainMenuScene.swift
//  Snake
//
//  Created by Brandon Price on 9/5/15.
//  Copyright (c) 2015 Brandon Price. All rights reserved.
//

import SpriteKit

class MainMenuScene: SKScene {
    
    // MARK: - Set Up Constants
    var xMax = CGFloat()
    var yMax = CGFloat()
    var xMin = CGFloat()
    var yMin = CGFloat()
    var xMid = CGFloat()
    var yMid = CGFloat()
    var Width = CGFloat()
    var Height = CGFloat()
    var PlayButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var HighScoresButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var SettingsButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    var Title = SKLabelNode()
    var SpawnBackgroundSquaresTimer1 = NSTimer()
    var SpawnBackgroundSquaresTimer2 = NSTimer()
    var HowToPlayButton = ButtonNode(Size: CGSize(), Position: CGPoint(), Label: "")
    
    override func didMoveToView(view: SKView) {
        
        // MARK: - Set Up Background
        self.backgroundColor = UIColor.whiteColor()
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
        let ButtonSize = CGSize(width: Width * 0.75, height: Height * 0.1)
        
        // Mark: - Place Title
        Title = SKLabelNode(text: "Snake")
        Title.position = CGPoint(x: xMid, y: yMid + (ButtonSize.height + 12) * 2.5)
        Title.fontColor = UIColor.blackColor()
        Title.fontSize = 100
        Title.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        self.addChild(Title)
        
        // Mark: - Place Buttons
        HighScoresButton = ButtonNode(Size: ButtonSize, Position: CGPoint(x: xMid, y: yMid), Label: "Highscores")
        self.addChild(HighScoresButton)
        
        PlayButton = ButtonNode(Size: ButtonSize, Position: CGPoint(x: xMid, y: yMid + (ButtonSize.height + 12)), Label: "Play")
        self.addChild(PlayButton)
        
        SettingsButton = ButtonNode(Size: ButtonSize, Position: CGPoint(x: xMid, y: yMid - (ButtonSize.height + 12)), Label: "Settings")
        self.addChild(SettingsButton)
        
        HowToPlayButton = ButtonNode(Size: ButtonSize, Position: CGPoint(x: xMid, y: yMid - (ButtonSize.height + 12) * 2), Label: "How To Play")
        self.addChild(HowToPlayButton)

    }
    
    // MARK: - touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            
            CheckTouchesBegan(location, ButtonList: [HighScoresButton,PlayButton,SettingsButton,HowToPlayButton])
            
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            
            CheckTouchesMoved(location, ButtonList: [HighScoresButton,PlayButton,SettingsButton,HowToPlayButton])

        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            
            CheckTouchesLifted(location, ButtonList: [HighScoresButton,PlayButton,SettingsButton,HowToPlayButton], ActionList: [OpenHighScores,PlayGame,OpenSettings,OpenHowToPlay])
            
        }
    }

    func PlayGame () {
        CloseMainMenu()
        let gameScene = GameScene(size: self.size)
        let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 1.0)
        gameScene.scaleMode = SKSceneScaleMode.ResizeFill
        self.scene!.view?.presentScene(gameScene, transition: transition)
    }
    
    func OpenHighScores () {
        CloseMainMenu()
        let highScoresScene = HighScoresScene(size: self.size)
        let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.5)
        highScoresScene.scaleMode = SKSceneScaleMode.ResizeFill
        self.scene!.view?.presentScene(highScoresScene, transition: transition)
    }
    
    func OpenSettings () {
        CloseMainMenu()
        let settingsScene = SettingsScene(size: self.size)
        let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 0.5)
        settingsScene.scaleMode = SKSceneScaleMode.ResizeFill
        self.scene!.view?.presentScene(settingsScene, transition: transition)
    }
    
    func StartBackgroundDesign () {
        SpawnBackgroundSquaresTimer1 = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: "SpawnSquare", userInfo: nil, repeats: true)
        
        SpawnBackgroundSquaresTimer2 = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "SpawnSquare", userInfo: nil, repeats: true)
    }
    
    func SpawnSquare () {
        let Square = BackgroundSquare(width: Width, height: Height, xMin: xMin, yMin: yMin)
        Square.zPosition = -10
        self.addChild(Square)
    }
    
    func CloseMainMenu () {
        SpawnBackgroundSquaresTimer1.invalidate()
        SpawnBackgroundSquaresTimer2.invalidate()
    }
    
    func OpenHowToPlay () {
        CloseMainMenu()
        let howToPlayScene = HowToPlayScene(size: self.size)
        let transition = SKTransition.fadeWithColor(UIColor.whiteColor(), duration: 1.0)
        howToPlayScene.scaleMode = SKSceneScaleMode.ResizeFill
        self.scene!.view?.presentScene(howToPlayScene, transition: transition)
    }
    
    // MARK: - update function
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
